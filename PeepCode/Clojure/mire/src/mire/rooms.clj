(ns mire.rooms)

(declare rooms)

(defn load-room [rooms file]
  (let [room (read-string (slurp (.getAbsolutePath file)))]
    (conj rooms {(keyword (.getName file))
                 {:desc        (:desc room)
                  :exits       (:exits room)
                  :inhabitants (ref #{})}})))

(defn load-rooms [dir]
  (reduce load-room {} (.listFiles (java.io.File. dir))))

(defn set-rooms [dir]
  (def rooms (load-rooms dir)))

(def *current-room*)
(def player-name)

(defn current-room []
  "Returns the current room"
  @*current-room*)

(defn current-inhabitants []
  "Returns the inhabitants in the current room"
  @(:inhabitants (current-room)))

(defn move-player-to [target]
  (dosync
   (alter (:inhabitants (current-room)) disj player-name)
   (alter (:inhabitants target)         conj player-name)
   (ref-set *current-room* target)))
