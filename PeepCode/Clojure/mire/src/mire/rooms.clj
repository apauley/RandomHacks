(ns mire.rooms)

(def rooms
     {:start {:desc "You don't know where you are. You can't see anything."
              :exits {:nowhere :start}}})

(defn set-current-room [target]
  (def *current-room* (rooms :start)))

(set-current-room :start)
