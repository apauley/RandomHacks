(ns mire.rooms)

(def rooms
     {:start {:desc "You are in an old, dusty room."
              :exits {:north :closet}}
      :closet {:desc "You are in a cramped closet. You feel a slight breeze."
               :exits {:south :start}}})

(def *current-room*)

(defn current-room []
  "Returns the current room"
  @*current-room*)

(defn set-current-room [target]
  (ref-set *current-room* target))
