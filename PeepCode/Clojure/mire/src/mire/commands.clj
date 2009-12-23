(ns mire.commands
  (:use [mire rooms player util])
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

(defn grab [thing]
  "Pick up something in the room"
  (if (current-room-contains? thing)
    (dosync
     (move-between-refs (keyword thing)
                        (:items (current-room))
                        *inventory*)
     (str "You picked up " thing "."))
    (str "There isn't any " thing " here.")))

(defn discard [thing]
  "Drop something you carry"
  (if (carrying? thing)
    (dosync
     (move-between-refs (keyword thing)
                        *inventory*
                        (:items (current-room)))
     (str "You are dropped the " thing "."))
    (str "You are not carrying any " thing ".")))

(defn inventory []
  "See what you are carrying"
  (str-join "\n " (conj @*inventory* "You are carrying:")))

(def commands
     {:move      move,
      :north     (fn [] (move :north)),
      :east      (fn [] (move :east)),
      :south     (fn [] (move :south)),
      :west      (fn [] (move :west)),
      :look      look,
      :grab      grab,
      :discard   discard,
      :inventory inventory,
      :wtf       (fn []
                   "Yeah sure, I'll do that right after you grow a brain.")})

(defn execute
  "Execute a command passed from the client"
  [input]
  (let [input-words (re-split #"\s+" input)
        command (keyword (first input-words))
        args (rest input-words)]
    (apply (command commands (:wtf commands)) args)))
