---
name: python-typing-patterns
description: >
  Comprehensive guide for Python type annotations, type checking, and modern typing patterns.
  Use when: (1) Adding type hints to Python code, (2) Configuring mypy/pyright/ty type checkers,
  (3) Understanding generics, protocols, and advanced type patterns, (4) Migrating to modern Python typing,
  (5) Setting up strict type checking in CI/CD, (6) Building type-safe APIs and libraries.
  Covers Python 3.10+ modern syntax, type narrowing, structural typing, and best practices.
---

# Python Typing Patterns

Master Python's type system to catch errors at static analysis time. Type annotations serve as enforced documentation that tooling validates automatically, improving code quality, enabling safer refactors, and enhancing IDE intelligence.

## When to Use This Skill

- Adding type hints to existing code or new projects
- Configuring mypy, pyright, or ty for strict type checking
- Understanding generics, protocols, and advanced type patterns
- Migrating from older typing syntax to modern Python 3.10+ patterns
- Setting up type checking in CI/CD pipelines
- Building type-safe APIs, libraries, and frameworks
- Understanding type narrowing, guards, and type-safe control flow
- Implementing structural typing with protocols

## Quick Start

```python
# Modern Python 3.10+ syntax
def get_user(user_id: str) -> User | None:
    """Return type makes 'might not exist' explicit."""
    ...

# Type checker enforces handling None case
user = get_user("123")
if user is None:
    raise UserNotFoundError("123")
print(user.name)  # Type checker knows user is User here
```

## Core Concepts

### 1. Type Annotations
Declare expected types for function parameters, return values, and variables. Types are enforced documentation.

### 2. Generics
Write reusable code that preserves type information across different concrete types.

### 3. Protocols
Define structural interfaces without inheritance (duck typing with type safety).

### 4. Type Narrowing
Use guards and conditionals to narrow types within code blocks, helping the type checker understand your logic.

## Modern Syntax (Python 3.10+)

### Union Types with `|`

```python
# Preferred (Python 3.10+)
def find_user(user_id: str) -> User | None:
    ...

def parse_value(v: str) -> int | float | str:
    ...

# Older style (Python 3.9 and earlier)
from typing import Optional, Union

def find_user(user_id: str) -> Optional[User]:  # or Union[User, None]
    ...
```

### Built-in Generic Types

```python
# Python 3.9+ - use built-in generics directly
from collections.abc import Callable, Iterator, Mapping

def process_items(items: list[str]) -> dict[str, int]:
    ...

def transform(data: tuple[int, ...]) -> set[str]:
    ...

# Python 3.8 and earlier - import from typing
from typing import List, Dict, Tuple, Set

def process_items(items: List[str]) -> Dict[str, int]:
    ...
```

### Type Aliases with `type` Statement

```python
# Python 3.10+ type statement for simple aliases
type UserId = str
type UserDict = dict[str, Any]

# Python 3.12+ type statement with generics
type Handler[T] = Callable[[Request], T]
type AsyncHandler[T] = Callable[[Request], Awaitable[T]]

# Python 3.9-3.11 style (broader compatibility)
from typing import TypeAlias

UserId: TypeAlias = str
Handler: TypeAlias = Callable[[Request], Response]
```

## Fundamental Patterns

### Pattern 1: Annotate All Public Signatures

Every public function, method, and class should have type annotations.

```python
def get_user(user_id: str) -> User:
    """Retrieve user by ID."""
    ...

def process_batch(
    items: list[Item],
    max_workers: int = 4,
) -> BatchResult[ProcessedItem]:
    """Process items concurrently."""
    ...

class UserRepository:
    def __init__(self, db: Database) -> None:
        self._db = db

    async def find_by_id(self, user_id: str) -> User | None:
        """Return User if found, None otherwise."""
        ...

    async def find_by_email(self, email: str) -> User | None:
        ...

    async def save(self, user: User) -> User:
        """Save and return user with generated ID."""
        ...
```

**Best Practice:** Use `mypy --strict` or `pyright` in CI to catch type errors early. For existing projects, enable strict mode incrementally using per-module overrides.

### Pattern 2: Type Narrowing with Guards

Use conditionals to narrow types for the type checker.

```python
def process_user(user_id: str) -> UserData:
    user = find_user(user_id)

    if user is None:
        raise UserNotFoundError(f"User {user_id} not found")

    # Type checker knows user is User here, not User | None
    return UserData(
        name=user.name,
        email=user.email,
    )

def process_items(items: list[Item | None]) -> list[ProcessedItem]:
    # Filter and narrow types
    valid_items = [item for item in items if item is not None]
    # valid_items is now list[Item]
    return [process(item) for item in valid_items]
```

### Pattern 3: Type Guards with `isinstance()`

```python
def handle_event(event: ClickEvent | KeyEvent) -> None:
    if isinstance(event, ClickEvent):
        # Type checker knows event is ClickEvent here
        process_click(event.x, event.y)
    else:
        # Type checker knows event is KeyEvent here
        process_key(event.key_code)
```

### Pattern 4: TypedDict for Structured Data

Use `TypedDict` for external schemas like API responses.

```python
from typing import TypedDict, NotRequired

class UserResponse(TypedDict):
    id: int
    name: str
    email: str
    age: NotRequired[int]  # Optional field

def process_api_response(data: UserResponse) -> User:
    # Type checker ensures all required keys are present
    return User(
        id=data["id"],
        name=data["name"],
        email=data["email"],
    )
```

## Generic Patterns

### Pattern 5: Generic Classes

Create type-safe reusable containers.

```python
from typing import TypeVar, Generic

T = TypeVar("T")
E = TypeVar("E", bound=Exception)

class Result(Generic[T, E]):
    """Represents either a success value or an error."""

    def __init__(
        self,
        value: T | None = None,
        error: E | None = None,
    ) -> None:
        if (value is None) == (error is None):
            raise ValueError("Exactly one of value or error must be set")
        self._value = value
        self._error = error

    @property
    def is_success(self) -> bool:
        return self._error is None

    @property
    def is_failure(self) -> bool:
        return self._error is not None

    def unwrap(self) -> T:
        """Get value or raise the error."""
        if self._error is not None:
            raise self._error
        return self._value  # type: ignore[return-value]

    def unwrap_or(self, default: T) -> T:
        """Get value or return default."""
        if self._error is not None:
            return default
        return self._value  # type: ignore[return-value]

# Usage preserves types
def parse_config(path: str) -> Result[Config, ConfigError]:
    try:
        return Result(value=Config.from_file(path))
    except ConfigError as e:
        return Result(error=e)

result = parse_config("config.yaml")
if result.is_success:
    config = result.unwrap()  # Type: Config
```

### Pattern 6: Generic Repository Pattern

Create type-safe data access patterns.

```python
from typing import TypeVar, Generic
from abc import ABC, abstractmethod

T = TypeVar("T")
ID = TypeVar("ID")

class Repository(ABC, Generic[T, ID]):
    """Generic repository interface."""

    @abstractmethod
    async def get(self, id: ID) -> T | None:
        """Get entity by ID."""
        ...

    @abstractmethod
    async def save(self, entity: T) -> T:
        """Save and return entity."""
        ...

    @abstractmethod
    async def delete(self, id: ID) -> bool:
        """Delete entity, return True if existed."""
        ...

class UserRepository(Repository[User, str]):
    """Concrete repository for Users with string IDs."""

    async def get(self, id: str) -> User | None:
        row = await self._db.fetchrow(
            "SELECT * FROM users WHERE id = $1", id
        )
        return User(**row) if row else None

    async def save(self, entity: User) -> User:
        ...

    async def delete(self, id: str) -> bool:
        ...
```

### Pattern 7: TypeVar with Bounds

Restrict generic parameters to specific types.

```python
from typing import TypeVar
from pydantic import BaseModel

ModelT = TypeVar("ModelT", bound=BaseModel)

def validate_and_create(model_cls: type[ModelT], data: dict) -> ModelT:
    """Create a validated Pydantic model from dict."""
    return model_cls.model_validate(data)

# Works with any BaseModel subclass
class User(BaseModel):
    name: str
    email: str

user = validate_and_create(User, {"name": "Alice", "email": "a@b.com"})
# user is typed as User

# Type error: str is not a BaseModel subclass
result = validate_and_create(str, {"name": "Alice"})  # Error!
```

### Pattern 8: Self Type (Python 3.11+)

Use `Self` for methods that return instances of the same class.

```python
from typing import Self

class Builder:
    def __init__(self) -> None:
        self._parts: list[str] = []

    def add_part(self, part: str) -> Self:
        self._parts.append(part)
        return self

    def build(self) -> str:
        return "".join(self._parts)

# Works with subclasses too
class AdvancedBuilder(Builder):
    def add_advanced(self, part: str) -> Self:
        self._parts.append(f"[{part}]")
        return self

builder = AdvancedBuilder()
result = builder.add_part("a").add_advanced("b").build()
```

## Protocol Patterns

### Pattern 9: Protocols for Structural Typing

Define interfaces without requiring inheritance.

```python
from typing import Protocol, runtime_checkable

@runtime_checkable
class Serializable(Protocol):
    """Any class that can be serialized to/from dict."""

    def to_dict(self) -> dict:
        ...

    @classmethod
    def from_dict(cls, data: dict) -> "Serializable":
        ...

# User satisfies Serializable without inheriting from it
class User:
    def __init__(self, id: str, name: str) -> None:
        self.id = id
        self.name = name

    def to_dict(self) -> dict:
        return {"id": self.id, "name": self.name}

    @classmethod
    def from_dict(cls, data: dict) -> "User":
        return cls(id=data["id"], name=data["name"])

def serialize(obj: Serializable) -> str:
    """Works with any Serializable object."""
    return json.dumps(obj.to_dict())

# Works - User matches the protocol
serialize(User("1", "Alice"))

# Runtime checking with @runtime_checkable
isinstance(User("1", "Alice"), Serializable)  # True
```

### Pattern 10: Common Protocol Patterns

Define reusable structural interfaces.

```python
from typing import Protocol

class Closeable(Protocol):
    """Resource that can be closed."""
    def close(self) -> None: ...

class AsyncCloseable(Protocol):
    """Async resource that can be closed."""
    async def close(self) -> None: ...

class Readable(Protocol):
    """Object that can be read from."""
    def read(self, n: int = -1) -> bytes: ...

class HasId(Protocol):
    """Object with an ID property."""
    @property
    def id(self) -> str: ...

class Comparable(Protocol):
    """Object that supports comparison."""
    def __lt__(self, other: "Comparable") -> bool: ...
    def __le__(self, other: "Comparable") -> bool: ...
```

## Callable Types

### Pattern 11: Function Callbacks

Type function parameters and callbacks.

```python
from collections.abc import Callable, Awaitable

# Sync callback
ProgressCallback = Callable[[int, int], None]  # (current, total)

# Async callback
AsyncHandler = Callable[[Request], Awaitable[Response]]

# With named parameters (using Protocol)
class OnProgress(Protocol):
    def __call__(
        self,
        current: int,
        total: int,
        *,
        message: str = "",
    ) -> None: ...

def process_items(
    items: list[Item],
    on_progress: ProgressCallback | None = None,
) -> list[Result]:
    for i, item in enumerate(items):
        if on_progress:
            on_progress(i, len(items))
        ...
```

## Type Checker Configuration

### Mypy Configuration

```toml
# pyproject.toml
[tool.mypy]
python_version = "3.12"
strict = true
warn_return_any = true
warn_unused_ignores = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
no_implicit_optional = true
show_error_codes = true

# Per-module overrides
[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false
```

### Pyright Configuration

```toml
# pyproject.toml
[tool.pyright]
pythonVersion = "3.12"
pythonPlatform = "Linux"
strict = ["src"]
include = ["src"]
exclude = ["**/node_modules", "**/__pycache__"]

# Type checking modes
# "basic" - standard type checking
# "standard" - more strict
# "strict" - maximum strictness
typeCheckingMode = "strict"
```

### Ty Configuration (Astral)

```toml
# pyproject.toml
[tool.ty.environment]
python-version = "3.12"
python = "./.venv"
python-platform = "linux"
root = ["./src"]

[tool.ty.rules]
possibly-unresolved-reference = "error"
invalid-argument-type = "error"
division-by-zero = "warn"
unused-ignore-comment = "warn"
```

## Advanced Patterns

### Pattern 12: @override Decorator (Python 3.12+)

Explicitly mark method overrides to catch signature mismatches.

```python
from typing import override

class Base:
    def process(self, data: str) -> str:
        return data.upper()

class Derived(Base):
    @override
    def process(self, data: str) -> str:  # Must match base signature
        return data.lower()

# Error if signature doesn't match base
class Wrong(Base):
    @override
    def process(self, data: int) -> str:  # Error: doesn't match base
        return str(data)
```

### Pattern 13: TypeVar with Constraints

Restrict TypeVar to specific types.

```python
from typing import TypeVar

# T can only be int, str, or bytes
StringOrNumber = TypeVar("StringOrNumber", int, str, bytes)

def concat(a: StringOrNumber, b: StringOrNumber) -> StringOrNumber:
    return a + b

concat(1, 2)        # OK: returns int
concat("a", "b")    # OK: returns str
concat(1, "a")      # Error: int and str don't match
```

### Pattern 14: Type Narrowing with TypeIs (Python 3.13+)

```python
from typing import TypeIs

def is_str_list(val: list[str] | list[int]) -> TypeIs[list[str]]:
    return len(val) > 0 and isinstance(val[0], str)

def process(val: list[str] | list[int]) -> None:
    if is_str_list(val):
        # Type checker knows val is list[str] here
        print("Strings:", ", ".join(val))
    else:
        # Type checker knows val is list[int] here
        print("Sum:", sum(val))
```

### Pattern 15: Intersection Types (Ty Exclusive)

ty has first-class intersection type support:

```python
def output_as_json(obj: Serializable) -> str:
    if isinstance(obj, Versioned):
        reveal_type(obj)  # reveals: Serializable & Versioned
        return str({
            "data": obj.serialize_json(),  # From Serializable
            "version": obj.version          # From Versioned
        })
    return obj.serialize_json()
```

## Best Practices Summary

1. **Annotate all public APIs** - Functions, methods, class attributes
2. **Use `T | None`** - Modern union syntax over `Optional[T]`
3. **Run strict type checking** - `mypy --strict` or `pyright` in CI
4. **Use generics** - Preserve type info in reusable code
5. **Define protocols** - Structural typing for interfaces
6. **Narrow types** - Use guards to help the type checker
7. **Bound type vars** - Restrict generics to meaningful types
8. **Create type aliases** - Meaningful names for complex types
9. **Minimize `Any`** - Use specific types or generics. `Any` is acceptable for truly dynamic data or when interfacing with untyped third-party code
10. **Document with types** - Types are enforceable documentation
11. **Use `@override`** - Explicitly mark method overrides (Python 3.12+)
12. **Prefer `Self`** - For fluent interfaces and builder patterns (Python 3.11+)

## Type Checking Commands

```bash
# Mypy
mypy src/                          # Check directory
mypy --strict src/                 # Strict mode
mypy --show-error-codes src/       # Show error codes

# Pyright
pyright src/                       # Check directory
pyright --strict src/              # Strict mode

# Ty (Astral)
ty check                           # Check current directory
ty check --output-format full      # Full diagnostics

# Ruff (includes type-aware linting)
ruff check src/                    # Lint with type awareness
```

## Incremental Adoption

For existing codebases, enable strict mode incrementally:

```toml
# pyproject.toml - Start with basic checks
[tool.mypy]
python_version = "3.12"
disallow_untyped_defs = true
warn_return_any = true

# Per-module strict mode
[[tool.mypy.overrides]]
module = "src.core.*"
strict = true

[[tool.mypy.overrides]]
module = "src.legacy.*"
disallow_untyped_defs = false
ignore_errors = true
```

## Resources

- [Mypy Documentation](https://mypy.readthedocs.io/)
- [Pyright Documentation](https://microsoft.github.io/pyright/)
- [Ty Documentation](https://docs.astral.sh/ty/)
- [Python Typing Documentation](https://docs.python.org/3/library/typing.html)
- [PEP 484 - Type Hints](https://peps.python.org/pep-0484/)
- [PEP 604 - Union Types with `|`](https://peps.python.org/pep-0604/)
- [PEP 673 - Self Type](https://peps.python.org/pep-0673/)
- [PEP 698 - Override Decorator](https://peps.python.org/pep-0698/)

## Sources

Built from best parts of:
- python-type-safety by wshobson (core patterns, generics, protocols)
- ty-skills by jiatastic (ty configuration, intersection types)
- python-backend-expert by hieutrtr (Pydantic v2, SQLAlchemy 2.0 patterns)
- Modern Python typing best practices from 2025 resources
