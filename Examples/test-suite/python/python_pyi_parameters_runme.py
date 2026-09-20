import ast
import python_pyi_parameters as m
from swig_test_utils import swig_assert, swig_assert_raises, swig_check

swig_check(m.size1(), 3)
swig_check(m.compact(2), 9)
swig_check(m.compact(2, 4), 6)
swig_check(m.plain(), "ready")
swig_check(m.plain("go"), "go")
swig_check(m.keywords(value=2, extra=3), 5)
swig_check(m.grouped(["a", "b"]), 2)
swig_check(m.output(), 11)
swig_check(m.combined(3), [3, 4])
swig_check(m.combined_default(), [7, 8])
w = m.Widget()
swig_check(w.size1(), 7)
swig_check(w.keyword(value=3), 3)
swig_check(m.Widget.make(), 7)
with swig_assert_raises(TypeError):
    m.size1(1)
with swig_assert_raises(TypeError):
    m.compact(value=1)

with open("python_pyi_parameters.pyi") as f:
    tree = ast.parse(f.read())
functions = {node.name: node for node in tree.body if isinstance(node, ast.FunctionDef)}
for name in ("size1", "compact", "plain", "keywords", "grouped", "output", "combined", "combined_default"):
    swig_assert(functions[name].args.vararg is None, "Explicit parameters missing for " + name)
for name in ("broad", "actual"):
    swig_assert(functions[name].args.vararg is not None, "Default dispatcher declaration changed for " + name)
swig_check(len(functions["size1"].args.args), 0)
swig_check(len(functions["output"].args.args), 0)
swig_check(len(functions["grouped"].args.args), 1)
swig_check(ast.literal_eval(functions["output"].returns), "int")
swig_check([arg.arg for arg in functions["keywords"].args.args], ["value", "extra"])
for name in ("compact", "plain", "keywords"):
    default = functions[name].args.defaults[0]
    swig_assert(type(default) is type(ast.parse("...").body[0].value), "Defaults must be ellipses")
widget = next(node for node in tree.body if isinstance(node, ast.ClassDef) and node.name == "Widget")
methods = {node.name: node for node in widget.body if isinstance(node, ast.FunctionDef)}
for name in ("__init__", "size1", "keyword", "make"):
    swig_assert(methods[name].args.vararg is None, "Explicit parameters missing for " + name)
swig_check([arg.arg for arg in methods["size1"].args.args], ["self"])
swig_check([arg.arg for arg in methods["keyword"].args.args], ["self", "value"])
