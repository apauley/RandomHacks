(ns mire.commands
  (:use [mire rooms])
  (:use [clojure.contrib str-utils]))

(defn move
  "We gotta get out of this place... Give a direction."
  [direction]
  (str "You are trying to go " direction))

(defn look []
  "Get a description of the current room"
  (str (:desc *current-room*)
       "\nExits: " (keys (:exits *current-room*))))

(def commands {:move move,
               :north (fn [] (move :north))
               :east  (fn [] (move :east))
               :south (fn [] (move :south))
               :west  (fn [] (move :west))
               :look  look
               :wtf   (fn []
                        "Yeah sure, I'll do that right after you grow a brain.")})

(defn execute
  "Execute a command passed from the client"
  [input]
  (let [input-words (re-split #"\s+" input)
        command (keyword (first input-words))
        args (rest input-words)]
    (apply (command commands (:wtf commands)) args)))
