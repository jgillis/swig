import ast
import python_pyi_overloads as m
from swig_test_utils import swig_assert, swig_check, swig_assert_raises

swig_check(m.multi(["a", "b"]), 2)
swig_check(m.multi(2.5), 2.5)
swig_check(m.ranked(True), 17)
swig_check(m.ranked(4), 4)
swig_check(m.choose(3), 3)
swig_check(m.choose("hello"), "hello")
swig_check(m.defaults(2), 5)
swig_check(m.compact(2), 9)
swig_check(m.produced(2), 3)
swig_check(m.produced("hello"), 5.5)
c = m.Choice(2)
swig_check(c.value, 9)
swig_check(m.Choice("abc").value, 3)
swig_check(c.pick("abc"), "abc")
swig_check(m.Choice.build(4), 4)
with swig_assert_raises(TypeError):
    m.choose(n=3)

with open("python_pyi_overloads.pyi") as f:
    source = f.read()
tree = ast.parse(source)
functions = {}
for item in tree.body:
    if isinstance(item, ast.FunctionDef):
        functions.setdefault(item.name, []).append(item)
swig_check(ast.literal_eval(functions["ranked"][0].args.args[0].annotation), "bool")
swig_check(len(functions["choose"]), 2)
swig_check(len(functions["duplicate"]), 1)
swig_check(len(functions["conflicting"]), 1)
swig_check(len(functions["broad"]), 1)
swig_assert(functions["broad"][0].args.vararg is not None, "Opt-out must retain catchall signature")
for name in ("choose", "defaults", "compact", "produced"):
    for item in functions[name]:
        swig_assert(item.args.vararg is None, "Typed overload must have explicit arguments")
        swig_assert(item.decorator_list, "Typed overload must have an overload decorator")
for name in ("defaults", "compact"):
    optional = [item for item in functions[name] if item.args.defaults]
    swig_check(len(optional), 1)
    swig_assert(type(optional[0].args.defaults[0]) is type(ast.parse("...").body[0].value), "Defaults must be ellipses")
returns = {ast.literal_eval(item.returns) for item in functions["produced"]}
swig_check(returns, {"int", "float"})
swig_assert("typing.Union[" in ast.literal_eval(functions["conflicting"][0].returns), "Collapsed input types need a union return")
choice = next(item for item in tree.body if isinstance(item, ast.ClassDef) and item.name == "Choice")
for name in ("__init__", "pick", "build"):
    methods = [item for item in choice.body if isinstance(item, ast.FunctionDef) and item.name == name]
    swig_check(len(methods), 2)
    if name == "__init__":
        swig_assert(all(ast.literal_eval(item.returns) == "None" for item in methods), "Constructors return None")
