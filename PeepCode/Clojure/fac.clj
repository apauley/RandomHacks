#!/usr/bin/env clj

(defn fac [n]
  "Returns the factorial of n"
  (if (= n 1)
    1
    (* n (fac (- n 1)))))

(println (fac 3))
