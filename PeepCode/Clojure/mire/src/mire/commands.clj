(ns mire.commands
  (:use [clojure.contrib str-utils]))

(defn current-time []
  (str "The current time is now " (java.util.Date.)))

(def commands {"time" current-time,
               "look" (fn [] "You see nothing. Yet.")})

(defn execute
  "Execute a command passed from the client"
  [input]
  (let [input-words (re-split #"\s+" input)
        command (first input-words)]
    ((commands command))))
