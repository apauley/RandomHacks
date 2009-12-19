(ns mire
  (:use [mire commands rooms])
  (:use [clojure.contrib server-socket duck-streams]))

(def port 3333)

(defn- print-prompt []
  (println)
  (print "> ")
  (flush))

(defn- mire-handle-client [in out]
  "Private function to handle client requests"

  ; Re-assign stdin and stdout
  (binding [*in*           (reader in)
            *out*          (writer out)
            *current-room* (rooms :start)]
    (println (look))
    (print-prompt)
    (loop [input (read-line)]
      (println (execute input))
      (print-prompt)
      (recur (read-line)))))

(def server (create-server port mire-handle-client))

(comment
  (close-server server)
  (add-classpath "file:///Users/andreas/Projekte/Persoonlik/RandomHacks/PeepCode/Clojure/mire/src/")
)
