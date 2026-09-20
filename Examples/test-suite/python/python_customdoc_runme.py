import python_customdoc as m
from swig_test_utils import swig_assert, swig_check

swig_check(m.singleton(3), 3)
swig_check(m.repeated(4), 4)
swig_check(m.choose(3), 3)
swig_check(m.choose(2.5), 2.5)
swig_check(m.Example(2).method(3), 5)
swig_check(m.Example.twice(3), 6)
swig_check(list(m.outputs(2, 4)), [2, 3, 6])

for name in ("singleton", "repeated"):
    swig_assert(name + "(integer value) -> integer" in getattr(m, name).__doc__)
swig_assert("choose(integer value) -> integer" in m.choose.__doc__)
swig_assert("choose(double value) -> double" in m.choose.__doc__)
groups = "\n".join(line.strip() for line in m.choose.__doc__.splitlines())
swig_assert(groups.index("GROUP\nchoose(integer") < groups.index("GROUP\nchoose(double"))
swig_assert('Quote """ and backslash \\ stay intact.' in m.quoted.__doc__)
swig_assert("method(self, integer argument) -> integer" in m.Example.method.__doc__)
swig_assert("twice(integer argument) -> integer" in m.Example.twice.__doc__)
swig_assert("-> (integer, integer, integer)" in m.outputs.__doc__)

def failure_message(function, argument, exception):
    try:
        function(argument)
    except exception as error:
        return str(error)
    raise RuntimeError("Expected " + exception.__name__)

for function in (m.singleton, m.choose, m.escaped):
    swig_assert("integer" in failure_message(function, object(), TypeError))
swig_assert('quoted "escaped"(integer)\nnext line' in failure_message(m.escaped, object(), TypeError))
swig_check(failure_message(m.fail_value, 1, ValueError), "original error")

swig_assert("default_format(integer value) -> integer" in m.default_format.__doc__)
swig_check(m.default_format(5), 5)
swig_assert("directional(kind=integer)" in failure_message(m.directional, object(), TypeError))
swig_check(m.shared.__doc__.count("The same documentation."), 1)
swig_assert("GROUP" not in m.shared.__doc__)
swig_assert("shared(integer value)" in m.shared.__doc__)
swig_assert("shared(double value)" in m.shared.__doc__)

swig_assert('Literal $overview, $main and $brief stay intact.' in m.literal_placeholders.__doc__)
swig_assert('Body contains $group and $proto.' in m.literal_placeholders.__doc__)
swig_assert('Before \\""" after \\ path \\u1234 and café.' in m.backslash_quotes.__doc__)
swig_assert('Both triple quotes: """ and \'\'\' and trailing slash\\' in m.quote_kinds.__doc__)
swig_assert("labelled_type(literal $name $in $out labelled) -> integer" in m.labelled_type.__doc__)
swig_assert("literal $name $in $out" in failure_message(m.labelled_type, object(), TypeError))
swig_assert("unnamed(integer 0/1, integer 1/2)" in m.unnamed.__doc__)
