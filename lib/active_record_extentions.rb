require 'active_record/connection_adapters/postgresql_adapter'
module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter
      alias :base_configure_connection :configure_connection
      def configure_connection
        base_configure_connection
        @connection.set_error_verbosity(PG::PQERRORS_VERBOSE)
      end
    end
  end
end