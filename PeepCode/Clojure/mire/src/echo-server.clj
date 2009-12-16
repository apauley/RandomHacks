(ns mire
  (:use [clojure.contrib server-socket duck-streams]))

(def port 3333)

(defn mire-handle-client [in out]
  (binding [*in* (reader in)    ; Re-assign stdin and stdout
            *out* (writer out)]
    (loop []
      (print "You typed: ")
      (println (read-line))
      (recur))))

(def server (create-server port mire-handle-client))

(comment
  (close-server server)
)
