require 'rubyvis'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :authorize_user
  helper_method :current_user
  helper_method :signed_in?
  helper_method :getMessage
  helper_method :getGraph
  
  @@messageFragments = {"hosts"=>"Hosts", 
                      "members"=>"Members", 
                      "categories"=>"Categories",
                      "arc"=>"are linked by an arc",
                      "matrix"=>"have their intersection colored"
                      }
                      
  @@topicSliceMethods = {"hosts"=>{"members"=>"hostsLinkedByMembers"},
                         "members"=>{"hosts"=>"membersLinkedByHosts"},
                         "categories"=>{"members"=>"categoriesLinkedByMembers"}
                         }
                      
  def getMessage topic, slice, view
    return "#{@@messageFragments[topic]} that share #{@@messageFragments[slice]} #{@@messageFragments[view]}."
  end
  
  def getGraph topic, slice, view
    method = @@topicSliceMethods[topic][slice]
    data = self.send(method)
    graph = self.send(view, data)
    return graph
  end
  
  def current_user
    return @current_user ||= User.find_by_id(session[:user_id])
  end
  
  def signed_in?
    return session[:user_id].present?
  end
   def authorize_user
    if !signed_in?
      redirect_to new_session_url, notice: 'Please sign in.'
    end
  end
  
  def tree
    vis = Rubyvis::Panel.new().width(800).height(800).left(0).right(0).top(0).bottom(0)

    tree = vis.add(Rubyvis::Layout::Tree).nodes(Rubyvis.dom(files).root("rubyvis").nodes()).orient('radial').depth(85).breadth(12)

    tree.link.add(Rubyvis::Line)

    tree.node.add(Rubyvis::Dot).
    fill_style(lambda {|n| n.first_child ? "#aec7e8" : "#ff7f0e"}).
    title(lambda {|n| n.node_name})

    tree.node_label.add(Rubyvis::Label).
    visible(lambda {|n| n.first_child})

    vis.render
    vis.to_svg
  end
  
  def arc data
    c=Rubyvis::Colors.category10()
    
    vis = Rubyvis::Panel.new() do
      width 1000
      height 500
      bottom 120
      layout_arc do
        nodes data.nodes
        links data.links
        sort {|a,b| a.group==b.group ? b.link_degree<=>a.link_degree : b.group <=> a.group}
    
        link.line
        
        node.dot do
          shape_size {|d| d.link_degree + 4}
          fill_style {|d| c[d.group]}
          stroke_style {|d| c[d.group].darker()}
        end
        
        node_label.label
      end
    end
    
    vis.render();
    vis.to_svg
  end
  
  def matrix data
    color=Rubyvis::Colors.category10
    vis = Rubyvis::Panel.new() do 
      width 500
      height 500
      top 100
      left 100
      layout_matrix do
        nodes data.nodes
        links data.links
        sort {|a,b| b.group<=>a.group }
        directed(false)
        link.bar do
          fill_style {|l| l.link_value!=0 ?
           ((l.target_node.group == l.source_node.group) ? color[l.source_node.group] : "#555") : "#eee"}
          antialias(false)
          line_width(1)
        end
        node_label.label do 
          text_style {|l| color[l.group]}
        end
      end
    end
    vis.render()
    vis.to_svg
  end
  
  def hostsLinkedByMembers
    hosts = Host.where(:user_id => current_user.id)
    hostNodes = []
    hostIdsToIndices = {}
    index = 0
    hosts.each do |h|
      hostNodes.push(OpenStruct.new({:node_value=>h.name, :group=>h.category.id}))
      hostIdsToIndices[h.id] = index
      index+=1
    end
    
    hostLinks = []
    members = Member.where(:user_id => current_user.id)
    members.each do |m|
      mHosts = m.hosts
      n = mHosts.count-1
      (0..n).each do |i|
        (i..n).each do|j|
          if i != j
            hostLinks.push(OpenStruct.new({:source=>hostIdsToIndices[mHosts[i].id], :target=>hostIdsToIndices[mHosts[j].id], :value=>1}))
          end
        end
      end
    end
    
    return OpenStruct.new({:nodes=>hostNodes, :links=>hostLinks})
  end
  
  def membersLinkedByHosts
    members = Member.where(:user_id => current_user.id)
    memberNodes = []
    memberIdsToIndices = {}
    index = 0
    members.each do |m|
      memberNodes.push(OpenStruct.new({:node_value=>m.name, :group=>m.hosts.count}))
      memberIdsToIndices[m.id] = index
      index+=1
    end
    
    hosts = Host.where(:user_id => current_user.id)
    memberLinks = []
    hosts.each do |h|
      hMembers = h.members
      n = hMembers.count-1
      (0..n).each do |i|
        (i..n).each do|j|
          if i != j
            memberLinks.push(OpenStruct.new({:source=>memberIdsToIndices[hMembers[i].id], :target=>memberIdsToIndices[hMembers[j].id], :value=>1}))
          end
        end
      end
    end
    
    return OpenStruct.new({:nodes=>memberNodes, :links=>memberLinks})
  end
  
  def categoriesLinkedByMembers
    cats = Category.where(:user_id => current_user.id)
    catNodes = []
    catIdsToIndices = {}
    index = 0
    cats.each do |c|
      catNodes.push(OpenStruct.new({:node_value=>c.name, :group=>c.id}))
      catIdsToIndices[c.id] = index
      index+=1
    end
    
    catLinks = []
    hmData = hostsLinkedByMembers
    hmData.links.each do |hLink|
      source = hmData.nodes[hLink.source].group
      target = hmData.nodes[hLink.target].group
      catLinks.push(OpenStruct.new({:source=>catIdsToIndices[source], :target=>catIdsToIndices[target], :value=>1}))
    end    
        
    return OpenStruct.new({:nodes=>catNodes, :links=>catLinks})
  end
end
