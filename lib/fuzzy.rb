# frozen_string_literal: true

require_relative "fuzzy/version"

module Fuzzy
  module_function
  
  # Find all alphanumeric tokens (words) in each string
  #
  # - treat them as a set
  # - construct two strings of the form:
  #     <sorted_intersection><sorted_remainder>
  # - take ratios of those two strings
  # - controls for unordered partial matches
  #
  # @return
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

    pairwise = [
      ratio(sorted_sect, combined_1to2),
      ratio(sorted_sect, combined_2to1),
      ratio(combined_1to2, combined_2to1)
    ]

    pairwise.max
  end

  def similarity_ratio(string1, string2)
    (MiniLevenshtein.similarity(string1, string2) * 100).round
  end
  alias ratio similarity_ratio
end
