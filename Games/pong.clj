;;;; Pong!
;;;;
;;;; Justin Grant
;;;; 2009/09/12
;;;; http://jng.imagine27.com/articles/2009-09-12-122605_pong_in_clojure.html


(ns i27.games.pong
  (:import (java.awt Color Toolkit Frame Dimension Font 
                     GraphicsDevice GraphicsEnvironment)
           (java.awt.event ActionListener MouseMotionListener KeyListener)
           (javax.swing JFrame JPanel Timer)))

(def width nil) (def height) (def timer nil)

(def started (ref false)) (def my (ref nil))
(def sx (ref nil)) (def sy (ref nil))
(def bx (ref nil)) (def by (ref nil)) 
(def px (ref 35)) (def py (ref nil))
(def cpx (ref nil)) (def cpy (ref nil))
(def score (ref nil)) 
(def bh (ref nil)) (def bw (ref @bh))
(def ph (ref nil)) (def pw (ref nil)) 
(def font1 (Font. "Courier New" Font/BOLD 24))
(def font2 (Font. "Courier New" Font/BOLD 44))

(defn new-game []
  (dosync 
   (ref-set bh (int (* height 0.0335))) (ref-set bw @bh)
   (ref-set ph (* @bh 5)) (ref-set pw @bw)
   (ref-set py (int (- (/ height 2) (/ @ph 2))))
   (ref-set cpx (- width @px @pw)) (ref-set cpy @py)
   (ref-set bx (int (- (/ width 2) (/ @bw 2))))
   (ref-set by (int (- (/ height 2) (/ @bh 2))))
   (ref-set sx 15) (ref-set sy 15)
   (ref-set score 0)))

(defn pong-frame[]
  (proxy [JFrame ActionListener MouseMotionListener KeyListener] []
    (paint [g]
           (proxy-super paint g)
           (.setColor g Color/WHITE)
           (.setFont g font1)
           (.drawString g (str "SCORE " @score) 20 20)
           (.fillRect g @px @py @pw @ph)
           (.fillRect g @cpx @cpy @pw @ph)
           (if @started
             (.fillRect g @bx @by @bw @bh)
             (do 
               (.setFont g font2)
               (.drawString g "PONG!" 
                            (- (/ width 2) 46) (- (/ height 2) 16))
               (.setFont g font1)
               (.drawString g "PRESS 'S' TO START, 'Q' TO QUIT"
                            (- (/ width 2) 200) (+ (/ height 2) 30)))))

    (mouseMoved [e] 
                (dosync
                 (ref-set my (.getY e))
                 (if (> (+ @my (/ @ph 2)) height)
                   (ref-set my (- height (/ @ph 2))))
                 (if (< @my (/ @ph 2))
                   (ref-set my (/ @ph 2)))
                 (ref-set py (- @my (/ @ph 2)))
                 (.repaint this)))

    (mouseDragged [e])

    (keyPressed [e]
                (if (= (. e getKeyChar) \s)
                  (dosync
                   (ref-set started false) (.stop timer)
                   (new-game)
                   (ref-set started true) (.start timer)))
                (if (= (. e getKeyChar) \q) (System/exit 0)))

    (keyReleased [e])

    (keyTyped [e])

    (actionPerformed [e]
                     (dosync 
                      ;; update ball position
                      (ref-set bx (+ @bx @sx)) (ref-set by (+ @by @sy))
                      ;; update ball y direction
                      (if (or (<= @by 0) (>= (+ @by @bh) height))
                        (ref-set sy (* -1 @sy)))
                      ;; check if player returns ball
                      (if (and (<= @bx (+ @px @pw)) (>= (+ @by @bh) @py)
                               (<= @by (+ @py @ph)) (> @bx @px))
                        (do 
                          (ref-set sx (* -1 @sx))
                          (alter score inc)
                          (ref-set sx (+ 1 @sx)))) ; game gets faster 
                      ;; check when computer returns ball
                      (if (and (>= (+ @bx @bw) @cpx) (>= (+ @by @bh) @cpy)
                               (<= @by (+ @cpy @ph)) (< @bx (+ @cpx @pw)))
                        (ref-set sx (* -1 @sx)))
                      ;; computer play
                      (if (< @sx 0)
                        (if (not (= (+ @cpy (/ @ph 2)) (/ height 2)))
                          (if (> (+ @cpy (/ @ph 2)) (/ height 2))
                            (ref-set cpy (- @cpy (* -1 @sx)))
                            (ref-set cpy (+ @cpy (* -1 @sx)))))
                        (if (<= (+ @by (/ @bh 2)) (+ @cpy (/ @ph 2)))
                          (ref-set cpy (- @cpy @sx))
                          (ref-set cpy (+ @cpy @sx))))
                      ;; computer paddle bound checks
                      (if (< @cpy 0) (ref-set cpy 0))
                      (if (> (+ @cpy @ph) height) (ref-set cpy (- height @ph)))
                      ;; check game over
                      (if (or (< (+ @bx @bw) 0) (> (+ @bx @bw) width))
                        (do
                          (ref-set py (- (/ height 2) (/ @ph 2)))
                          (.stop timer) (ref-set started false) )))
                     (.repaint this))))

(defn start[]
  (let [game (pong-frame)
        tk (. Toolkit getDefaultToolkit)
        ge (GraphicsEnvironment/getLocalGraphicsEnvironment)
        gd (. ge getDefaultScreenDevice)]
    (def timer (Timer. 20 game))
    (def width (.. tk getScreenSize width))
    (def height (.. tk getScreenSize height))
    (if (not (. game isDisplayable)) (. game setUndecorated true))
    (doto game 
      (.setResizable false)
      (.setBackground Color/BLACK)
      (.addMouseMotionListener game) (.addKeyListener game)
      (.setLocation 0 0) (.setSize width height))
    (. gd setFullScreenWindow game)
    (. game setVisible true)
    (. game createBufferStrategy 2))
  (new-game))

(start)
