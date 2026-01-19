# ingenium Documentation

Welcome to the ingenium documentation hub. This centralized resource provides comprehensive information about the ingenium FiveM framework.

## ⚡ Latest Updates

### Character Connection Fixes (2026-01-16) ✅ COMPLETE
- **[Character Connection Status](./CHARACTER_CONNECTION_STATUS.md)** - Overview of all fixes applied
- **[Character Connection Fixes](./CHARACTER_CONNECTION_FIXES.md)** - Detailed technical documentation
- **[Character Connection Code Reference](./CHARACTER_CONNECTION_CODE_REFERENCE.md)** - Side-by-side code comparisons
- **Issues Fixed**: 8 critical issues resolved in client-server character lifecycle
- **Impact**: Character selection, loading, and initialization now fully functional

## 📚 Core Systems

### Character System (Recently Updated)
- **[Class System Architecture](./Class%20System%20Architecture.md)** - Entity lifecycle and class patterns
- **[CLIENT_CHARACTER_LIFECYCLE_ANALYSIS](./CLIENT_CHARACTER_LIFECYCLE_ANALYSIS.md)** - Client-side analysis (reference)

### Internationalization & Debugging
- **[i18n and Debugging Guide](./I18N_AND_DEBUGGING.md)** - Multi-language support and enhanced error tracking
- **[i18n & Debug Examples](./EXAMPLES_I18N_DEBUG.lua)** - Code examples for locale and debugging features

### Zone Management
- **[Zone Management (ig.zone)](./Zone_Management.md)** - Integrated PolyZone system for zone definition and checking
- **[IPL Management (ig.ipl/ig.ipls)](./Zone_IPL_Management.md)** - Interior prop list loading with zone triggers

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
- **[Discord Integration](./Discord_Integration.md)** - Internal Discord role-based authentication and queue priority

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

#### Locale Configuration
Set your preferred language in `_config/config.lua`:
```lua
conf.locale = "en"  -- Options: "en", "fr", "es", "de", "pt"
```

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
1. Review the [i18n and Debugging Guide](./I18N_AND_DEBUGGING.md) to understand localization and error tracking
2. Review the [SQL Architecture](./SQL_Architecture.md) to understand the database layer
3. Check [Security Guide](./Security_Guide.md) for security best practices
4. Explore [SQL API Reference](./SQL_API_Reference.md) for available functions

## 📖 Feature Documentation

### Inventory System
- Comprehensive documentation available in repository documentation

### Appearance System
- Character customization and appearance management

### Job Management System
- **[Job Management UI](./Job_Management_UI.md)** - Complete job management interface documentation
- **[Job Management Implementation](../Implementations/Job_Management_UI_Implementation.md)** - Server integration guide
- **[Job Management Visual Guide](./Job_Management_UI_Visual_Guide.md)** - UI component preview and styling

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

### Internationalization & Debugging (v1.1.0+)
- Multi-language support (English, French, Spanish, German, Portuguese)
- Enhanced error tracking with resource name, file path, and line numbers
- Structured debug levels (ERROR, WARN, INFO, DEBUG, TRACE)
- Server-side error logging to files
- Function wrapping for automatic error handling
- Backward compatible with existing debug functions

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
