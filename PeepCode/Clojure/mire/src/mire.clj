(ns mire
  (:use [mire commands])
  (:use [clojure.contrib server-socket duck-streams]))

(def port 3333)

(defn- print-prompt []
  (println)
  (print "> ")
  (flush))

(defn- mire-handle-client [in out]
  "Private function to handle client requests"
  
  (binding [*in* (reader in) ; Re-assign stdin and stdout
            *out* (writer out)]
    (print-prompt)
    (loop [input (read-line)]
      (println (execute input))
      (print-prompt)
      (recur (read-line)))))

(def server (create-server port mire-handle-client))

(comment
  (close-server server)
)
