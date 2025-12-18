# Contributing to ig.core

Thank you for your interest in contributing to ig.core! This document provides guidelines and standards for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Standards](#code-standards)
- [Documentation Standards](#documentation-standards)
- [Testing Requirements](#testing-requirements)
- [Pull Request Process](#pull-request-process)
- [SQL Development Guidelines](#sql-development-guidelines)

## Code of Conduct

- Be respectful and constructive
- Focus on what is best for the community
- Show empathy towards other community members
- Accept constructive criticism gracefully

## Getting Started

### Prerequisites

- FiveM Server (latest recommended)
- MySQL 5.7+ or MariaDB 10.3+
- Git
- Code editor (VSCode recommended)
- Lua 5.4 knowledge
- Basic SQL knowledge

### Setup Development Environment

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/ig.core.git`
3. Create a feature branch: `git checkout -b feature/your-feature-name`
4. Configure your test server with ig.core
5. Set up your database connection in `server.cfg`

## Development Workflow

1. **Create an Issue** (for significant changes)
   - Describe the problem or feature
   - Discuss approach with maintainers
   - Get approval before starting work

2. **Make Changes**
   - Work in a feature branch
   - Commit often with clear messages
   - Test thoroughly

3. **Document Changes**
   - Update relevant documentation
   - Add examples for new features
   - Update API references

4. **Submit Pull Request**
   - Fill out PR template completely
   - Link related issues
   - Request review

## Code Standards

### Lua Code Style

#### Naming Conventions

```lua
-- Variables: camelCase
local playerName = "John"
local characterId = 12345

-- Constants: UPPER_SNAKE_CASE
local MAX_PLAYERS = 128
local DEFAULT_HEALTH = 100

-- Functions: PascalCase for global, camelCase for local
function GlobalFunction() end
local function localHelper() end

-- Tables/Objects: camelCase
local playerData = {}
ig.sql.char = {}

-- Boolean variables: prefix with Is/Has/Should
local isAlive = true
local hasPermission = false
local shouldSave = true
```

#### Indentation and Spacing

```lua
-- Use 4 spaces for indentation (no tabs)
function Example()
    if condition then
        -- Code here
    end
end

-- Space after commas
local array = {item1, item2, item3}

-- Space around operators
local result = value1 + value2
local isValid = health > 0 and armour >= 0
```

#### Comments

```lua
-- Single line comments use --

--[[
Multi-line comments use
this format
]]--

--- Function documentation comments use three dashes
---@param playerId number Player server ID
---@param amount number Amount to add
---@return boolean Success status
function AddMoney(playerId, amount)
    -- Implementation
end
```

### JavaScript Code Style

```javascript
// Use const/let (no var)
const playerCount = 10;
let currentTime = Date.now();

// Arrow functions for callbacks
array.forEach((item) => {
    console.log(item);
});

// Async/await for promises
async function fetchData() {
    const result = await pool.execute(query);
    return result;
}
```

## Documentation Standards

### **MANDATORY DOCUMENTATION**

**ALL code changes MUST include documentation updates.**

### What to Document

1. **New Functions**: Add to appropriate API reference
2. **New Events**: Add to `Documentation/SQL_Events_Exports.md`
3. **New Exports**: Add to exports documentation
4. **Changed Behavior**: Update affected documentation
5. **New Features**: Create examples and usage guides

### Documentation Structure

```markdown
### FunctionName

Brief description of what the function does.

**Syntax:**
```lua
ig.sql.FunctionName(param1, param2, callback)
```

**Parameters:**
- `param1` (type) - Description
- `param2` (type, optional) - Description
- `callback` (function, optional) - Description

**Returns:**
- `type` - Description of return value

**Examples:**
```lua
-- Example 1: Basic usage
local result = ig.sql.FunctionName(value1, value2)

-- Example 2: With callback
ig.sql.FunctionName(value1, value2, function(result)
    print("Done")
end)
```
```

### Documentation Files

| Type of Change | Documentation File |
|----------------|-------------------|
| SQL API functions | `Documentation/SQL_API_Reference.md` |
| Events/Exports | `Documentation/SQL_Events_Exports.md` |
| Performance | `Documentation/SQL_Performance.md` |
| Architecture | `Documentation/SQL_Architecture.md` |
| Security | `Documentation/Security_Guide.md` |
| Testing | `Documentation/Testing_Guide.md` |

### Documentation Quality Checklist

- [ ] Clear, concise descriptions
- [ ] Code examples for all public APIs
- [ ] Parameter descriptions with types
- [ ] Return value documentation
- [ ] Error handling examples
- [ ] Links to related documentation

## Testing Requirements

### Required Tests

1. **Unit Tests**: Test individual functions
2. **Integration Tests**: Test system interactions
3. **Performance Tests**: Benchmark critical paths
4. **Security Tests**: Run CodeQL scans

### Testing SQL Changes

```lua
-- Test basic functionality
RegisterCommand('testsql', function()
    -- Test query
    local result = ig.sql.Query("SELECT * FROM users LIMIT 1", {})
    assert(#result >= 0, "Query failed")
    
    -- Test insert
    local id = ig.sql.Insert("INSERT INTO test VALUES (?)", {"data"})
    assert(id > 0, "Insert failed")
    
    -- Cleanup
    ig.sql.Update("DELETE FROM test WHERE id = ?", {id})
    
    print("Tests passed!")
end, true)
```

### Performance Testing

- Benchmark queries with `ig.sql.GetStats()`
- Monitor slow queries with `ig:sql:slowQuery` event
- Test with realistic player counts
- Profile save operations

## Pull Request Process

### Before Submitting

1. **Self-Review**
   - Review your own code
   - Check for debug statements
   - Verify documentation is complete
   - Run local tests

2. **Documentation Check**
   - All new functions documented
   - All events/exports documented
   - Examples provided
   - API references updated

3. **Testing**
   - All tests pass
   - Performance tested
   - Security scanned (if relevant)

### PR Requirements

- **Title**: Clear, descriptive summary
- **Description**: Complete PR template
- **Documentation**: All relevant docs updated
- **Tests**: Proof of testing provided
- **Review**: Request review from maintainers

### PR Template Sections

Fill out ALL sections of the PR template:
- Description
- Type of Change
- Related Issues
- Changes Made
- **Documentation** (REQUIRED)
- Testing
- Code Quality
- Checklist

### Review Process

1. **Automated Checks**: CI/CD runs tests
2. **Code Review**: Maintainer reviews code
3. **Documentation Review**: Verify docs complete
4. **Testing Review**: Verify adequate testing
5. **Approval**: PR approved for merge

### Merge Criteria

- ✅ All CI checks pass
- ✅ Code review approved
- ✅ Documentation complete
- ✅ Tests pass
- ✅ No merge conflicts
- ❌ **Missing documentation = BLOCKER**

## SQL Development Guidelines

### Query Best Practices

```lua
-- Good: Use prepared statements
local query = ig.sql.PrepareQuery("UPDATE chars SET data = ? WHERE id = ?")
ig.sql.ExecutePrepared(query, {data, id})

-- Good: Use positional parameters
ig.sql.Query("SELECT * FROM users WHERE id = ?", {userId})

-- Good: Limit result sets
ig.sql.Query("SELECT * FROM chars WHERE active = TRUE LIMIT 100", {})

-- Bad: String concatenation
local query = "SELECT * FROM users WHERE id = " .. userId -- SQL INJECTION RISK!

-- Bad: Selecting everything
ig.sql.Query("SELECT * FROM chars", {}) -- Returns too much data
```

### Security Requirements

1. **Always** use parameterized queries
2. **Never** concatenate user input into SQL
3. **Always** validate input before queries
4. **Use** prepared statements for repeated queries
5. **Limit** result sets with WHERE and LIMIT

### Performance Guidelines

1. Use indexes on frequently queried columns
2. Use prepared statements for high-frequency operations
3. Batch operations when possible
4. Monitor with `ig.sql.GetStats()`
5. Optimize slow queries (>150ms)

## Versioning

We use [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

## Questions?

- Open an issue for questions
- Join our Discord (if available)
- Check existing documentation first

## License

By contributing, you agree that your contributions will be licensed under the project's license.

---

## Documentation Requirements

### For New Features
When implementing new features, you must provide two types of documentation:

1. **User Documentation** (in `/Documentation/`)
   - API references
   - How-to guides
   - Usage examples
   - Migration guides (if applicable)

2. **Implementation Documentation** (in `/Implementations/`)
   - Technical decision records
   - Implementation approach and rationale
   - Challenges faced and solutions
   - Architecture diagrams (if applicable)
   - Testing approach

### Documentation Structure

- **`/Documentation/`** - User-facing guides and API references for those using ig.core
- **`/Implementations/`** - Technical implementation details for contributors and maintainers

### Implementation Document Template

When creating implementation documentation, include:

```markdown
# [Feature Name] Implementation

## Overview
Brief description of what was implemented and why.

## Technical Decisions
Key architectural and technical decisions made during implementation.

## Implementation Details
How the feature was built, including:
- File structure
- Key functions/modules
- Data flow
- Integration points

## Challenges and Solutions
Problems encountered during implementation and how they were resolved.

## Testing
How the feature was tested and validated.

## Related Documentation
Links to user documentation, API references, and other relevant docs.
```

### Example Workflow

1. Implement your feature
2. Create user documentation in `/Documentation/`
3. Create implementation documentation in `/Implementations/`
4. Update relevant README files with links
5. Submit PR with code + documentation

Good documentation helps future contributors understand not just *what* the code does, but *why* decisions were made.

---

## Quick Reference

### Before Every PR

- [ ] Code follows style guide
- [ ] All functions documented
- [ ] Tests added/updated
- [ ] PR template completed
- [ ] Documentation updated
- [ ] Self-reviewed code
- [ ] No debug logs committed

### Documentation Checklist

- [ ] Function signatures documented
- [ ] Parameters described with types
- [ ] Return values documented
- [ ] Examples provided
- [ ] Related docs linked
- [ ] API reference updated

### Thank You!

Your contributions make ig.core better for everyone. Thank you for taking the time to contribute!
