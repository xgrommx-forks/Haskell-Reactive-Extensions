{-# LANGUAGE FlexibleInstances #-}
module Rx.Observable
       ( Scheduler
       , IObservable (..)
       , Observable (..)
       , IObserver (..)
       , ToObserver (..)
       , ToAsyncObservable (..)
       , ToSyncObservable (..)
       , Async
       , Sync
       , Disposable
       , subscribe
       , safeSubscribe
       , subscribeObserver
       , dispose
       , Observable.completeTimeout
       , Observable.filter
       , Observable.foldLeft
       , Observable.map
       , Observable.mapM
       , Observable.repeat
       , Observable.repeat'
       , Observable.repeatEvery
       , Observable.repeatEvery'
       , Observable.scanLeft
       , Observable.scanLeftWithItem
       , Observable.timer
       ) where

import Control.Applicative (Applicative (..))
import Control.Monad       (ap)

import qualified Rx.Observable.Filter  as Observable
import qualified Rx.Observable.Fold    as Observable
import qualified Rx.Observable.Map     as Observable
import qualified Rx.Observable.Merge   as Observable
import qualified Rx.Observable.Repeat  as Observable
import qualified Rx.Observable.Scan    as Observable
import qualified Rx.Observable.Take    as Observable
import qualified Rx.Observable.Take    as Observable
import qualified Rx.Observable.Timer   as Observable
import qualified Rx.Observable.Timeout as Observable

import Rx.Disposable (Disposable, dispose)
import Rx.Scheduler  (Async, Scheduler, Sync, newThread, schedule)

import Rx.Observable.Types

instance Functor (Observable s) where
  fmap = Observable.map

instance Applicative (Observable Async) where
  pure result =
    Observable $ \observer ->
      schedule newThread $
        onNext observer result
  (<*>) = ap

instance Monad (Observable Async) where
  return = pure
  (>>=)  = Observable.flatMap
