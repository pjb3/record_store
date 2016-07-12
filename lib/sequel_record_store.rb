class SequelRecordStore
  VERSION = "0.4.0"

  class << self
    def database
      raise "You must setup your database"
    end

    def dataset_name
      @dataset_name ||= name.sub(/Store$/,'').tableize.to_sym
    end

    def dataset
      database[dataset_name]
    end

    def get(id)
      dataset.where(id: id).first
    end
    alias_method :[], :get

    def put(record)
      new(record).put
    end
    alias_method :<<, :put

    def type_column_map(database)
      @type_column_map ||= database.schema(dataset_name).each_with_object({}) do |(column,metadata),map|
        map[metadata[:db_type]] ||= []
        map[metadata[:db_type]] << column
      end
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
    typecast
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
    self.class.database
  end

  def dataset
    self.class.dataset
  end

  def errors
    @errors ||= []
  end

  def typecast
    if database.database_type == :postgres
      Array(self.class.type_column_map(database)['json']).each do |json_column|
        if @record[json_column]
          @record[json_column] = Sequel.pg_json(@record[json_column])
        end
      end
    end
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
    @record[:id] = dataset.insert(@record.except(:errors))
  end

  def update
    dataset.where(id: @record[:id]).update(@record.except(:id, :errors))
  end
end
