base = matlab_director.Callback();
assert(matlab_director.invoke(base, 2) == 2);
callback = MatlabDirector();
assert(callback.value(2) == 12);
assert(matlab_director.invoke(callback, 2) == 12);
assert(matlab_director.invoke_split(base, 2) == 5);
assert(matlab_director.invoke_split(callback, 2) == 54);
delete(callback);
delete(base);
