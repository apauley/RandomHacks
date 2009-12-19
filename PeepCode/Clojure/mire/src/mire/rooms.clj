(ns mire.rooms)

(def rooms
     {:start {:desc "You are in an old, dusty room."
              :exits {:north :closet}}
      :closet {:desc "You are in a cramped closet. You feel a slight breeze."
               :exits {:south :start}}})

(defn set-current-room [target]
  (def *current-room* target))

(set-current-room (rooms :start))
