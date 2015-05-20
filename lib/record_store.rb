class RecordStore
  VERSION = "0.1.0"

  class << self
    def put(record)
      new(record).put
    end
    alias_method :<<, :put

    def dataset_name
      @dataset_name ||= name.sub(/Store$/,'').tableize.to_sym
    end

    def validations
      @validations ||= []
    end

    def required_attributes(*record)
      record.each do |attribute|
        validations << proc do
          errors << "#{attribute.to_s.titleize} is required" unless @record[attribute].present?
        end
      end
    end

    def required_foreign_key(attribute, table)
      validations << proc do
        if @record[attribute].blank?
          errors << "#{attribute} is required"
        elsif database[table].where(id: @record[attribute]).get(:id).blank?
          errors << "no #{table.to_s.singularize} with id=#{@record[attribute]}"
        end
      end
    end
  end

  def initialize(record)
    @record = record
  end

  def put
    transform
    return { errors: 'no record provided' } if @record.blank?
    validate
    return { errors: errors } if errors.present?

    save
  end

  def save
    if exists?
      update
    else
      insert
    end
    @record
  end

  def database
    raise "You must setup your database"
  end

  def dataset
    database[self.class.dataset_name]
  end

  def errors
    @errors ||= []
  end

  def transform
  end

  def validate
    self.class.validations.each do |validation|
      instance_eval(&validation)
    end
  end

  def exists?
    !dataset.select(1).where(id: @record[:id]).empty?
  end

  def insert
    dataset.insert(@record)
  end

  def update
    dataset.where(id: @record[:id]).update(@record.except(:id))
  end
end
