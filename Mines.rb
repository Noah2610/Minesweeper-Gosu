#!/bin/env ruby

####################################################
###                 Minesweeper!                 ###
###              by Noah Rosenzweig              ###
### https://github.com/Noah2610/Minesweeper-Gosu ###
####################################################

DIR = "./#{File.dirname(__FILE__)}"
require 'gosu'
require 'yaml'
require 'byebug'

require File.join DIR, 'src/Settings'
require File.join DIR, 'src/Resource'
require File.join DIR, 'src/Panel'
require File.join DIR, 'src/Grid'
require File.join DIR, 'src/Cell'
require File.join DIR, 'src/main'


