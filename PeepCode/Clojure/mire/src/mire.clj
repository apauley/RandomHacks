(add-classpath (str "file://" (.getParent (java.io.File. *file*)) "/"))

(ns mire
  (:use [mire commands rooms player util])
  (:use [clojure.contrib server-socket duck-streams]))

(def port 3333)

(defn- print-prompt []
  (println)
  (print-flush "> "))

(defn- mire-handle-client [in out]
  "Private function to handle client requests"

  ; Re-assign stdin and stdout
  (binding [*in*           (reader in)
            *out*          (writer out)]

    (print-flush "\nWhat is your name? ")
    (binding [*player-name*  (read-line)
              *current-room* (ref (rooms :start))
              *inventory*    (ref #{})]
      (move-player-to (current-room))
      (println (look))
      (print-prompt)
      (loop [input (read-line)]
        (println (execute input))
        (print-prompt)
        (recur (read-line))))))

(set-rooms "../data/rooms")
(def server (create-server port mire-handle-client))

(comment
  (close-server server)
  (add-classpath "file:///Users/andreas/Projekte/Persoonlik/RandomHacks/PeepCode/Clojure/mire/src/")
)
