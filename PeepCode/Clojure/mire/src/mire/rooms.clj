(ns mire.rooms
  (:use [mire player util]))

(declare rooms)

(defn load-room [rooms file]
  (let [room (read-string (slurp (.getAbsolutePath file)))]
    (conj rooms {(keyword (.getName file))
                 {:desc        (:desc room)
                  :exits       (:exits room)
                  :items       (ref (or (:items room) #{}))
                  :inhabitants (ref #{})}})))

(defn load-rooms [dir]
  (reduce load-room {} (.listFiles (java.io.File. dir))))

(defn set-rooms [dir]
  (def rooms (load-rooms dir)))

(def *current-room*)

(defn current-room []
  "Returns the current room"
  *current-room*)

(defn current-inhabitants []
  "Returns the inhabitants in the current room"
  (:inhabitants @(current-room)))

(defn current-items []
  "Returns the items available in the current room"
  (:items @(current-room)))

(defn room-contains? [room thing]
  (@(:items room) (keyword thing)))

(defn current-room-contains? [thing]
  (room-contains? @(current-room) thing))

(defn move-player-to [target]
  (dosync
   (move-between-refs *player-name*
                      (:inhabitants @(current-room))
                      (:inhabitants target))
   (ref-set *current-room* target)))
