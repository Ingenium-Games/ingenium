/**
 * MySQL2 Connection Pool Manager for FiveM (Ingenium)
 */
const mysql = require('mysql2/promise');

class ConnectionPool {
    constructor() {
        this.pool = null;
        this.isReady = false;
        this.config = {
            host: GetConvar('mysql_connection_string', '').match(/mysql:\/\/([^:]+)/)?.[1] || 
                  GetConvar('mysql_host', 'localhost'),
            port: parseInt(GetConvar('mysql_port', '5001')),
            user: GetConvar('mysql_user', 'root'),
            password: GetConvar('mysql_password', ''),
            database: GetConvar('mysql_database', 'fivem'),
            charset: GetConvar('mysql_charset', 'utf8mb4'),
            waitForConnections: true,
            connectionLimit: parseInt(GetConvar('mysql_connection_limit', '10')),
            queueLimit: 0,
            enableKeepAlive: true,
            keepAliveInitialDelay: 10000,
            timezone: '+00:00',
            supportBigNumbers: true,
            bigNumberStrings: false,
            dateStrings: true
        };

        this.stats = {
            totalQueries: 0,
            slowQueries: 0,
            failedQueries: 0,
            totalTime: 0
        };
    }

    async initialize() {
        try {
            const connectionString = GetConvar('mysql_connection_string', '');
            if (connectionString && connectionString.startsWith('mysql://')) {
                const url = new URL(connectionString);
                this.config.host = url.hostname;
                this.config.port = parseInt(url.port) || 5001;
                this.config.user = url.username;
                this.config.password = url.password;
                this.config.database = url.pathname.substring(1);
            }

            this.pool = mysql.createPool(this.config);

            // Test connection
            const connection = await this.pool.getConnection();
            console.log(`^2[SQL] Connected to MySQL database: ${this.config.database}@${this.config.host}:${this.config.port}^7`);
            connection.release();

            this.isReady = true;
            emit('ig:sql:ready');
            return true;
        } catch (error) {
            console.error(`^1[SQL ERROR] Failed to initialize connection pool: ${error.message}^7`);
            console.error(`^1[SQL ERROR] Config: ${this.config.host}:${this.config.port}/${this.config.database}^7`);
            this.isReady = false;
            return false;
        }
    }

    async getConnection() {
        if (!this.isReady) {
            throw new Error('Connection pool is not initialized');
        }
        return await this.pool.getConnection();
    }

    async execute(query, parameters = []) {
        const startTime = process.hrtime.bigint();
        try {
            const [results] = await this.pool.execute(query, parameters);
            const endTime = process.hrtime.bigint();
            const duration = Number(endTime - startTime) / 1000000;
            this.stats.totalQueries++;
            this.stats.totalTime += duration;
            if (duration > 150) {
                this.stats.slowQueries++;
                console.log(`^3[SQL WARNING] Slow query (${duration.toFixed(2)}ms): ${query.substring(0, 100)}...^7`);
                emit('ig:sql:slowQuery', { query, duration, parameters });
            }
            emit('ig:sql:queryExecuted', { query, duration, success: true });
            return results;
        } catch (error) {
            this.stats.failedQueries++;
            console.error(`^1[SQL ERROR] Query failed: ${error.message}^7`);
            console.error(`^1[SQL ERROR] Query: ${query}^7`);
            console.error(`^1[SQL ERROR] Parameters: ${JSON.stringify(parameters)}^7`);
            emit('ig:sql:queryExecuted', { query, duration: 0, success: false, error: error.message });
            throw error;
        }
    }

    getStats() {
        const avgTime = this.stats.totalQueries > 0 ? this.stats.totalTime / this.stats.totalQueries : 0;
        return {
            ...this.stats,
            averageTime: avgTime,
            isReady: this.isReady,
            config: {
                host: this.config.host,
                port: this.config.port,
                database: this.config.database,
                connectionLimit: this.config.connectionLimit
            }
        };
    }

    async close() {
        if (this.pool) {
            await this.pool.end();
            this.isReady = false;
            console.log('^3[SQL] Connection pool closed^7');
        }
    }

    ready() {
        return this.isReady;
    }
}

// Singleton!
const poolSingleton = new ConnectionPool();

// Export for use in other modules/resources
global.exports('getPool', () => poolSingleton);
global.exports('isReady', () => poolSingleton.ready());
global.exports('getStats', () => poolSingleton.getStats());

setImmediate(async () => {
    await poolSingleton.initialize();
});

on('onResourceStop', (resourceName) => {
    if (resourceName === GetCurrentResourceName()) poolSingleton.close();
});