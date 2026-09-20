for value = {'hello', char([945 946 947]), char([97 0 98]), repmat('x', 1, 1024)}
  assert(isequal(li_std_wstring.test_value(value{1}), value{1}));
  assert(isequal(li_std_wstring.test_const_reference(value{1}), value{1}));
end
assert(strcmp(li_std_wstring.test_ccvalue('abc'), 'abc'));
assert(li_std_wstring.test_wcvalue('h') == 'h');
