require 'sequel'

DB = Sequel.connect(ENV['DATABASE_URL'] || {adapter: 'postgres', database: 'contacts'})

# data storage api for 'simple contacts application'
class DataPersistence
  def initialize(logger)
    DB.logger = logger
  end

  def all_contacts
    DB[:contacts].all
  end

  # cnt_info array contains fn, ln, num, email
  # groups array contains names of groups, in which the contact is in
  def create_new_contact(cnt_info, groups)
    id = DB[:contacts].insert(
      first_name: cnt_info[0],
      last_name: cnt_info[1],
      email: cnt_info[3],
      number: cnt_info[2]
    )

    assing_contact_to_goup(groups, id)
  end

  # int: id, suplied by route, cnt_info array contains fn, ln, num, email
  # groups array contains names of groups, in which the contact is in
  def update_contact(id, cnt_info, groups)
    DB[:contacts]
      .where(id: id)
      .update(
        first_name: cnt_info[0],
        last_name: cnt_info[1],
        email: cnt_info[3],
        number: cnt_info[2]
      )

    DB[:groups_contacts].where(contact_id: id).delete
    assing_contact_to_goup(groups, id)
  end

  # needs to return array, even if empty --> all
  def find_contact(first_name, last_name)
    DB[:contacts].where(first_name: first_name, last_name: last_name).all
  end

  # returns an array of goups in which the contact is in
  def groups_by_contact(first_name, last_name)
    cnt_id = find_contact(first_name, last_name).first[:id]

    DB[:contacts]
      .join(:groups_contacts, contact_id: :id)
      .join(:groups, id: :group_id)
      .select_group(:groups__name)
      .where(contacts__id: cnt_id)
      .all
      .map(&:values)
      .flatten
  end

  def delete_contact(id, first_name, last_name)
    DB[:groups_contacts].where(contact_id: id).delete
    DB[:contacts].where(first_name: first_name, last_name: last_name).delete
  end

  def all_groups
    DB[:groups].all
  end

  def create_new_group(name)
    DB[:groups].insert(name: name)
  end

  def find_group(name)
    DB[:groups].where(name: name).all
  end

  def contacts_by_group(name)
    DB[:contacts]
      .join(:groups_contacts, contact_id: :id)
      .join(:groups, id: :group_id)
      .select_all(:contacts)
      .where(groups__name: name).all
  end

  def delete_group(name)
    id = DB[:groups].where(name: name).select { :id }.first[:id]

    DB[:groups_contacts].where(group_id: id).delete
    DB[:groups].where(id: id).delete
  end

  private

  def assing_contact_to_goup(groups, contact_id)
    groups.each do |g|
      grp_id = DB[:groups].where(name: g).select { :id }.first[:id]
      DB[:groups_contacts].insert(contact_id: contact_id, group_id: grp_id)
    end
  end
end
