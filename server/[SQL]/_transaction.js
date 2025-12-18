/**
 * Transaction Handler
 * Manages database transactions with rollback support
 */


class TransactionManager {
    /**
     * Execute multiple queries in a transaction
     * @param {Array} queries - Array of {query, parameters} objects
     * @param {Function} callback - Callback(success, results)
     */
    static async transaction(queries, callback = null) {
        let connection = null;
        
        try {
            const pool = getPool();
            connection = await pool.getConnection();
            
            // Start transaction
            await connection.beginTransaction();
            
            const results = [];
            
            // Execute all queries
            for (const item of queries) {
                let query = item.query || item;
                let parameters = item.parameters || item.params || [];
                
                // Convert named parameters if needed
                if (parameters && typeof parameters === 'object' && !Array.isArray(parameters)) {
                    const paramValues = [];
                    query = query.replace(/@(\w+)/g, (match, paramName) => {
                        const value = parameters[`@${paramName}`] || parameters[paramName];
                        paramValues.push(value !== undefined ? value : null);
                        return '?';
                    });
                    parameters = paramValues;
                }
                
                const [result] = await connection.execute(query, parameters);
                results.push(result);
            }
            
            // Commit transaction
            await connection.commit();
            
            console.log(`^2[SQL] Transaction completed successfully (${queries.length} queries)^7`);
            
            if (callback && typeof callback === 'function') {
                callback(true, results);
            }
            
            return { success: true, results };
            
        } catch (error) {
            console.error(`^1[SQL] Transaction error: ${error.message}^7`);
            
            // Rollback on error
            if (connection) {
                try {
                    await connection.rollback();
                    console.log('^3[SQL] Transaction rolled back^7');
                } catch (rollbackError) {
                    console.error(`^1[SQL] Rollback error: ${rollbackError.message}^7`);
                }
            }
            
            if (callback && typeof callback === 'function') {
                callback(false, []);
            }
            
            return { success: false, results: [] };
            
        } finally {
            // Release connection back to pool
            if (connection) {
                connection.release();
            }
        }
    }

    /**
     * Execute a batch of queries without transaction (fire and forget)
     * Useful for non-critical updates that don't need atomicity
     */
    static async batch(queries, callback = null) {
        try {
            const pool = getPool();
            const results = [];
            
            for (const item of queries) {
                try {
                    let query = item.query || item;
                    let parameters = item.parameters || item.params || [];
                    
                    // Convert named parameters if needed
                    if (parameters && typeof parameters === 'object' && !Array.isArray(parameters)) {
                        const paramValues = [];
                        query = query.replace(/@(\w+)/g, (match, paramName) => {
                            const value = parameters[`@${paramName}`] || parameters[paramName];
                            paramValues.push(value !== undefined ? value : null);
                            return '?';
                        });
                        parameters = paramValues;
                    }
                    
                    const result = await pool.execute(query, parameters);
                    results.push({ success: true, result });
                } catch (error) {
                    console.error(`^3[SQL] Batch query error (continuing): ${error.message}^7`);
                    results.push({ success: false, error: error.message });
                }
            }
            
            const successCount = results.filter(r => r.success).length;
            console.log(`^2[SQL] Batch completed: ${successCount}/${queries.length} queries succeeded^7`);
            
            if (callback && typeof callback === 'function') {
                callback(results);
            }
            
            return results;
            
        } catch (error) {
            console.error(`^1[SQL] Batch error: ${error.message}^7`);
            
            if (callback && typeof callback === 'function') {
                callback([]);
            }
            
            return [];
        }
    }
}

// Export transaction functions
global.exports('transaction', (queries, cb) => TransactionManager.transaction(queries, cb));
global.exports('batch', (queries, cb) => TransactionManager.batch(queries, cb));
