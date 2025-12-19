# ingenium Documentation

Welcome to the ingenium documentation hub. This centralized resource provides comprehensive information about the ingenium FiveM framework.

## 📚 Core Systems

### SQL & Database
- **[SQL Architecture](./SQL_Architecture.md)** - Overview of the integrated MySQL2 SQL system
- **[SQL API Reference](./SQL_API_Reference.md)** - Complete API documentation for SQL operations
- **[SQL Migration Guide](./SQL_Migration_Guide.md)** - Step-by-step migration from mysql-async
- **[SQL Events & Exports](./SQL_Events_Exports.md)** - Server events, exports, and commands
- **[SQL Performance](./SQL_Performance.md)** - Performance optimization and monitoring
- **[SQL Compatibility](./SQL_Compatibility.md)** - Legacy MySQL.Async compatibility layer

### Validation & Security
- **[Validation Architecture](./Validation_Architecture.md)** - Centralized validation system
- **[Security Guide](./Security_Guide.md)** - Security best practices and implementation

### Data & Migration
- **[Migration Infrastructure](./Migration_Infrastructure.md)** - Data migration system and tools

### Testing
- **[Testing Guide](./Testing_Guide.md)** - Testing frameworks and procedures

## 🚀 Quick Start

### Prerequisites
- FiveM Server (latest recommended)
- OneSync Infinity enabled
- MySQL 5.7+ or MariaDB 10.3+
- Node.js 16+ (for NUI development)

### Configuration

#### MySQL Connection
Set one of the following in your `server.cfg`:

```bash
# Option 1: Connection string
set mysql_connection_string "mysql://user:password@host:port/database"

# Option 2: Individual parameters
set mysql_host "localhost"
set mysql_port "3306"
set mysql_user "root"
set mysql_password "yourpassword"
set mysql_database "fivem"
set mysql_connection_limit "10"
```

### First Steps
1. Review the [SQL Architecture](./SQL_Architecture.md) to understand the database layer
2. Check [Security Guide](./Security_Guide.md) for security best practices
3. Explore [SQL API Reference](./SQL_API_Reference.md) for available functions

## 📖 Feature Documentation

### Inventory System
- Comprehensive documentation available in repository documentation

### Appearance System
- Character customization and appearance management

### Drop System
- Item drop mechanics and world interaction

## 🤝 Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on:
- Code style and standards
- Documentation requirements
- Pull request process
- Testing requirements

## 📝 Additional Resources

### Architecture Documents
All architecture and implementation documents are organized in this `Documentation/` folder for easy reference.

### Support
- Report issues via GitHub Issues
- Check existing documentation before requesting features
- Follow contribution guidelines for pull requests

## 🔄 Recent Updates

### SQL System Overhaul (v0.9.0+)
- Integrated MySQL2 in-resource implementation
- Removed external mysql-async dependency
- Added performance profiling and monitoring
- Improved prepared statement handling
- Full backward compatibility layer

## Related Resources

- [Implementation Documentation](../Implementations/README.md) - Technical details on how features were built
- [Contributing Guidelines](../CONTRIBUTING.md) - How to contribute to this project

---

**Note**: This documentation is actively maintained. Last updated: 2025-12-15
