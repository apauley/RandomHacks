(ns mire.commands
  (:use [clojure.contrib str-utils]))

(defn move
  "We gotta get out of this place... Give a direction."
  [direction]
  (str "You are trying to go " direction))

(def *current-room*
     {:desc "You don't know where you are. You can't see anything."})

(defn look []
  "Get a description of the current room"
  (:desc *current-room*))

(def commands {"move" move,
               "north" (fn [] (move :north))
               "look" look})

(defn execute
  "Execute a command passed from the client"
  [input]
  (let [input-words (re-split #"\s+" input)
        command (first input-words)
        args (rest input-words)]
    (apply (commands command) args)))
