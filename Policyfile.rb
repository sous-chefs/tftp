# frozen_string_literal: true

name 'tftp'

run_list 'recipe[test::default]'

cookbook 'tftp', path: '.'
cookbook 'test', path: 'test/cookbooks/test'
