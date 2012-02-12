module BillHelper

  def sponsor_mugs(sponsors, options = {})
    mugs = ''.html_safe
    i = 0
    limit = options.delete(:limit) || 0
    summary = options.delete(:summary) || false
    
    sponsors.each do |s|
     if s.sponsor_id? && !s.sponsor.photo_url.blank?
       mugs += link_to(photo_for(s.sponsor, :tiny), person_path(s.sponsor), :rel => 'tipsy', :title => s.sponsor.full_name + ', ' + s.kind_fm + ' ()', :class => 'sponsor_mug')
#       mugs += link_to(photo_for(s.sponsor, :tiny), person_path(s.sponsor), :rel => 'tipsy', :title => s.sponsor.full_name + ', ' + s.kind_fm + ' (' + s.sponsor.current_role.try(:affiliation_fm) + ')', :class => 'sponsor_mug')
       i += 1
     end
     break if i == limit && limit > 0
    end
    
    sponsors_left = sponsors.size - i
    if summary && sponsors_left > 0 && !mugs.blank?
      mugs + content_tag(:span, "and #{pluralize(sponsors_left, 'other')}.", :class => "other_sponsor_count")
    else
      mugs
    end
  end

  def status_bar(bill)
    status_items = ''
    status_cell_count = 0

    if bill.actions.introduced?
      status_items += content_tag(:li, 'Introduced', :class => 'grid_2 alpha omega')
      status_cell_count += 2
    end
    
    if bill.actions.referred_to_committee?
      status_items += content_tag(:li, 'Referred to Committee', :class => 'grid_3 alpha omega')
      status_cell_count += 3
    end

    if bill.actions.passed?
      status_items += content_tag(:li, 'Bill Passed', :class => 'grid_3 alpha omega')
      status_cell_count += 3
    elsif bill.actions.failed?
      status_items += content_tag(:li, 'Bill Failed', :class => 'grid_3 alpha omega')
      status_cell_count += 3
    end

    status_items += content_tag(:li, 'Law', :class => 'law')

    if status_cell_count > 0
      status_cell_count += 1
      haml_tag "div.grid_#{status_cell_count}.alpha#{(bill.actions.signed? ? '.is_law' : '')}" do
        haml_tag "h2" do
          output_buffer << t('.status')
        end
        haml_tag "ul.status_bar.grid_#{status_cell_count}.alpha" do
          output_buffer << status_items
        end
      end
    else
      output_buffer << %q{We can't determine the status of this bill at the moment.}
    end
  end
  
  def short_bill_link(bill, length = 80)
    link_to(bill.bill_number, bill_path(bill.session, bill), :class => "bill_link") + content_tag(:span, truncate(bill.title, :length => length), :title => bill.title, :rel => (bill.title.length > length ? 'tipsy' : ''))
  end

end
