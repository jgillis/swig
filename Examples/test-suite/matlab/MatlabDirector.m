classdef MatlabDirector < matlab_director.Callback
  methods
    function self = MatlabDirector()
      self@matlab_director.Callback();
    end
    function [result, extra] = split(self, value)
      result = value + 20;
      extra = value + 30;
    end
    function result = value(self, value)
      result = value + 10;
    end
  end
end
