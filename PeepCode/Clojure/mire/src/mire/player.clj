(ns mire.player
  (:use clojure.contrib.seq-utils))

(def *inventory*)

(defn carrying? [thing]
  (includes? @*inventory* (keyword thing)))
