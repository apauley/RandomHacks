(ns mire.player
  (:use clojure.contrib.seq-utils))

(def *player-name*)
(def *inventory*)

(defn carrying? [thing]
  (includes? @*inventory* (keyword thing)))
