(ns mire.commands
  (:use [mire rooms])
  (:use [clojure.contrib str-utils]))

(defn look []
  "Get a description of the current room"
  (str "\n"
       (:desc (current-room))
       "\nInhabitants: " (current-inhabitants)
       "\nItems: "       (current-items)
       "\nExits: " (keys (:exits (current-room)))))

(defn move
  "We gotta get out of this place... Give a direction."
  [direction]
  (let [target-name ((:exits (current-room)) (keyword direction))
         target (rooms target-name)]
     (if target
       (do (move-player-to target)
           (look))
       "No way.")))

(def commands {:move move,
               :north (fn [] (move :north)),
               :east  (fn [] (move :east)),
               :south (fn [] (move :south)),
               :west  (fn [] (move :west)),
               :look  look,
               :wtf   (fn []
                        "Yeah sure, I'll do that right after you grow a brain.")})

(defn execute
  "Execute a command passed from the client"
  [input]
  (let [input-words (re-split #"\s+" input)
        command (keyword (first input-words))
        args (rest input-words)]
    (apply (command commands (:wtf commands)) args)))
