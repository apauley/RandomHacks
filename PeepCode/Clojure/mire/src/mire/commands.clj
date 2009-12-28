(ns mire.commands
  (:use [mire rooms player util])
  (:use [clojure.contrib str-utils]))

(defn look []
  "Get a description of the current room"
  (str "\n"
       (:desc @(current-room))
       "\nInhabitants: " @(current-inhabitants)
       "\nItems: "       @(current-items)
       "\nExits: " (keys (:exits @(current-room)))))

(defn move
  "We gotta get out of this place... Give a direction."
  [direction]
  (let [target-name ((:exits @(current-room)) (keyword direction))
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
                        (:items @(current-room))
                        *inventory*)
     (str "You picked up the " thing "."))
    (str "There isn't any " thing " here.")))

(defn discard [thing]
  "Drop something you carry"
  (if (carrying? thing)
    (dosync
     (move-between-refs (keyword thing)
                        *inventory*
                        (:items @(current-room)))
     (str "You dropped the " thing "."))
    (str "You are not carrying any " thing ".")))

(defn inventory []
  "See what you are carrying"
  (str-join "\n " (conj @*inventory* "You are carrying:")))

(defn detect [item]
  "If you have the detector, you can see which room an item is in."
  (if (@*inventory* :detector)
    (if-let [room (first (filter #((:items %) (keyword item))
                                 (vals rooms)))]
      (str item " is in " (:name room))
      (str item " is not in any room."))
    "You need to be carrying the detector for that."))

(def commands
     {:move      move,
      :north     #(move :north),
      :east      #(move :east),
      :south     #(move :south),
      :west      #(move :west),
      :look      look,
      :grab      grab,
      :discard   discard,
      :inventory inventory,
      :detect    detect,
      :wtf       #(str "You need help.")})

(defn execute
  "Execute a command passed from the client"
  [input]
  (let [input-words (re-split #"\s+" input)
        command (keyword (first input-words))
        args (rest input-words)]
    (apply (command commands (:wtf commands)) args)))
