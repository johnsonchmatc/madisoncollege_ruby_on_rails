#Ruby on Rails Development
##Week 7
---
#Demo
* cd into ```wolfies_list```
* ```$ git add . ```
* ```$ git commit -am 'commiting files from in class'```
* ```$ git fetch```
* ```$ git pull ```
* ```$ git checkout week07_start```

^ ```
# Add some debug params
<%= debug(params) if Rails.env.development? %>

# imports.css.scss
@import "bootstrap-sprockets";
@import "bootstrap";

# debug.css.scss

/* mixins, variables, etc. */

$gray-medium-light: #eaeaea;

@mixin box_sizing {
  -moz-box-sizing:    border-box;
  -webkit-box-sizing: border-box;
  box-sizing:         border-box;
}


.debug_dump {
  clear: both;
  float: left;
  width: 100%;
  margin-top: 45px;
  @include box_sizing;
}

# Add users resource to routes
resources :users

# Add show method to users controller
def show
  @user = User.find(params[:id])
end

# Add show view
<%= @user.name %>, <%= @user.email %>

# Add new user functionality
  def new
    @user = User.new
  end

<h1>Signup</h1>

<%= form_for(@user, :html => {class: 'form-horizontal'}) do |f| %>
<fieldset>
  <legend></legend>
  <div class='form_group'>
    <%= f.label :name, class: 'col-lg-2 control-label' %>
    <div class='col-lg-10'>
      <%= f.text_field :name, class: 'form-control' %>
    </div>
  </div>
  <div class='form_group'>
    <%= f.label :email, class: 'col-lg-2 control-label' %>
    <div class='col-lg-10'>
      <%= f.email_field :email, class: 'form-control' %>
    </div>
  </div>
  <div class='form_group'>
    <%= f.label :password, class: 'col-lg-2 control-label' %>
    <div class='col-lg-10'>
      <%= f.password_field :password, class: 'form-control' %>
    </div>
  </div>
  <div class='form_group'>
    <%= f.label :password_confirmation, "Confirmation", class: 'col-lg-2 control-label' %>
    <div class='col-lg-10'>
      <%= f.password_field :password_confirmation, class: 'form-control' %>
    </div>
  </div>
  <div class='form_group'>
    <%= f.submit "Create my account", class: "btn btn-primary" %>
  </div>
</fieldset>
<% end %>

 def create
  @user = User.new(user_params)    # Not the final implementation!
  if @user.save
    # Handle a successful save.
  else
    render 'new'
  end
end 

private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end



#### \_errors.html.erb ######
<% if model.errors.any? %>
  <div id="error_explanation">
    <div class="alert alert-danger">
      The form contains <%= pluralize(model.errors.count, "error") %>.
    </div>
    <ul>
    <% model.errors.full_messages.each do |msg| %>
      <li><%= msg %></li>
    <% end %>
    </ul>
  </div>
<% end %>


### Add to new.html.erb
<%= render partial: "shared/errors", locals: {model: @user} %>


### Add success to create
flash[:success] = "Welcome to the Sample App!"
redirect_to @user


###Flash message to layout
<% flash.each do |message_type, message| %>
<div class="row">
  <div class="col-lg-12">
    <div class="alert-dismissible alert-<%= message_type %>">
      <h4><%= message_type %></h4>
      <button type="button" class="close" data-dismiss="alert">×</button>
      <p><%= message %></p>
    </div>
  </div>
</div>
<% end %>
```

---
