(ns mire.rooms)

(def rooms
     {:start {:desc "You are in an old, dusty room."
              :exits {:north :closet}
              :inhabitants (ref #{})}
      :closet {:desc "You are in a cramped closet. You feel a slight breeze."
               :exits {:south :start}
               :inhabitants (ref #{})}})

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
