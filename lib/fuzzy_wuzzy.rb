# frozen_string_literal: true

require 'set'
require 'mini-levenshtein'

require_relative "fuzzy_wuzzy/version"

module FuzzyWuzzy
  class << self
    # Find all alphanumeric tokens (words) in each string
    #
    # - treat them as a set
    # - construct two strings of the form:
    #     <sorted_intersection><sorted_remainder>
    # - take ratios of those two strings
    # - controls for unordered partial matches
    #
    # @param string1 [String]
    # @param string2 [String]
    # @param force_ascii [Boolean]
    # @param preprocess [Boolean]
    #
    # @return [Integer]
    def token_set_ratio(string1, string2, force_ascii: true, preprocess: true)
      return 100 if !preprocess && string1 == string2

      p1 = preprocess ? preprocess(string1, force_ascii: force_ascii) : string1
      p2 = preprocess ? preprocess(string2, force_ascii: force_ascii) : string2

      tokens1 = p1.split.to_set
      tokens2 = p2.split.to_set

      intersect = tokens1 & tokens2
      diff1to2  = tokens1 - tokens2
      diff2to1  = tokens2 - tokens1

      sorted_sect = intersect.sort.join(' ')
      sorted_1to2 = diff1to2.sort.join(' ')
      sorted_2to1 = diff2to1.sort.join(' ')

      combined_1to2 = sorted_sect + sorted_1to2
      combined_2to1 = sorted_sect + sorted_2to1

      sorted_sect.strip!
      combined_1to2.strip!
      combined_2to1.strip!

      max(
        ratio(sorted_sect, combined_1to2),
        ratio(sorted_sect, combined_2to1),
        ratio(combined_1to2, combined_2to1)
      )
    end

    def ratio(string1, string2)
      (MiniLevenshtein.ratio(string1, string2) * 100).round
    end

    # Return the ratio of the most similar substring as a number between 0 and 100.
    #
    # @param string1 [String]
    # @param string2 [String]
    #
    # @return [Integer]
    def partial_ratio(string1, string2)
      
    end

    private

    def preprocess(string, force_ascii: false)
      str = string.gsub(/\W+/, ' ')
      if force_ascii
        str.force_encoding('ascii')
        str.scrub!
      end
      str.downcase!
      str.strip!
      str
    end

    def max(a, b, c)
      max = a > b ? a : b

      max > c ? max : c
    end
  end
end

