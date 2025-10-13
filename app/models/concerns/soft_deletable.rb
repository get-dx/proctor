module SoftDeletable
  extend ActiveSupport::Concern

  included do
    # Default scope to exclude soft deleted records
    default_scope { where(deleted_at: nil) }

    # Scope to include soft deleted records
    scope :with_deleted, -> { unscope(where: :deleted_at) }
    scope :only_deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) }
  end

  # Override destroy to perform soft delete
  def destroy
    return false unless valid?
    
    run_callbacks :destroy do
      update_column(:deleted_at, Time.current)
    end
    
    self
  end

  # Hard delete - actually remove from database
  def destroy!
    with_deleted { super }
  end

  # Check if record is soft deleted
  def deleted?
    deleted_at.present?
  end

  # Restore a soft deleted record
  def restore
    update_column(:deleted_at, nil)
  end

  # Override persisted? to account for soft delete
  def persisted?
    super && !deleted?
  end

  private

  def with_deleted
    self.class.unscoped { yield }
  end
end