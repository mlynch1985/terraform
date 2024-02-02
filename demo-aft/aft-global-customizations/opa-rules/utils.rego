package utils

array_contains(arr, elem) {
  arr[_] = elem
}

array_contains_regex(arr, elem) {
  regex.find_n(arr[_], elem, -1)
}

cast_array(x) = [x] {not is_array(x)} else = x {true}

has_key(x, k) { 
	_ = x[k]
}

empty_or_null("") = true
empty_or_null(null) = true