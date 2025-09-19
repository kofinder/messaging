defmodule Messaging.Repo.Migrations.CreateFunctionForShop do

  use Ecto.Migration

  @table_name "shop_notification"
  @function_name "notify_shop"
  @event_name "shop_notification_changed"

  def up do
    execute("""
      CREATE OR REPLACE FUNCTION #{@function_name}()
      RETURNS trigger AS $$
      BEGIN
        PERFORM pg_notify(
          '#{@event_name}',
          json_build_object(
            'operation', TG_OP,
            'record', row_to_json(NEW)
          )::text
        );

        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    """)
  end

  def down do
    execute("DROP FUNCTION IF EXISTS #{@function_name} CASCADE")
  end
end
