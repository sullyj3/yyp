#!/usr/bin/env bats

setup() {
  script="./src/yyp.sh"
  temp_dir="$(mktemp -d)"
  test_file="$temp_dir/test_file"
  test_dir="$temp_dir/test_dir"
  echo "test" > "$test_file"
  mkdir "$test_dir"
  
  non_existent_file="$temp_dir/non_existent_file"
}

teardown() {
  rm -r "$temp_dir"
}

# Happy path tests
@test "yank a file and put it" {
  run "$script" yank "$test_file"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Yanked $test_file" ]
  
  run "$script" put
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "cp -i $test_file ." ]
}

@test "yank a directory and put it" {
  run "$script" yank "$test_dir"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Yanked $test_dir" ]
  
  run "$script" put
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "cp -i -r $test_dir ." ]
}

# Edge case tests
@test "yank a non-existent file" {
  run "$script" yank "$non_existent_file"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "$non_existent_file does not exist" ]
}
