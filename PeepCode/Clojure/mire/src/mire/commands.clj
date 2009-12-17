(ns mire.commands)

(defn current-time []
  (str "The current time is now " (java.util.Date.)))

(def commands {"time" current-time,
               "look" (fn [] "You see nothing. Yet.")})

(defn execute
  "Execute a command passed from the client"
  [input]
  ((commands input)))
