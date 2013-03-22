require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ResponsesController do

  # This should return the minimal set of attributes required to create a valid
  # Response. As you add validations to Response, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "question_id" => "1" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ResponsesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all responses as @responses" do
      response = Response.create! valid_attributes
      get :index, {}, valid_session
      assigns(:responses).should eq([response])
    end
  end

  describe "GET show" do
    it "assigns the requested response as @response" do
      response = Response.create! valid_attributes
      get :show, {:id => response.to_param}, valid_session
      assigns(:response).should eq(response)
    end
  end

  describe "GET new" do
    it "assigns a new response as @response" do
      get :new, {}, valid_session
      assigns(:response).should be_a_new(Response)
    end
  end

  describe "GET edit" do
    it "assigns the requested response as @response" do
      response = Response.create! valid_attributes
      get :edit, {:id => response.to_param}, valid_session
      assigns(:response).should eq(response)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Response" do
        expect {
          post :create, {:response => valid_attributes}, valid_session
        }.to change(Response, :count).by(1)
      end

      it "assigns a newly created response as @response" do
        post :create, {:response => valid_attributes}, valid_session
        assigns(:response).should be_a(Response)
        assigns(:response).should be_persisted
      end

      it "redirects to the created response" do
        post :create, {:response => valid_attributes}, valid_session
        response.should redirect_to(Response.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved response as @response" do
        # Trigger the behavior that occurs when invalid params are submitted
        Response.any_instance.stub(:save).and_return(false)
        post :create, {:response => { "question_id" => "invalid value" }}, valid_session
        assigns(:response).should be_a_new(Response)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Response.any_instance.stub(:save).and_return(false)
        post :create, {:response => { "question_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested response" do
        response = Response.create! valid_attributes
        # Assuming there are no other responses in the database, this
        # specifies that the Response created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Response.any_instance.should_receive(:update_attributes).with({ "question_id" => "1" })
        put :update, {:id => response.to_param, :response => { "question_id" => "1" }}, valid_session
      end

      it "assigns the requested response as @response" do
        response = Response.create! valid_attributes
        put :update, {:id => response.to_param, :response => valid_attributes}, valid_session
        assigns(:response).should eq(response)
      end

      it "redirects to the response" do
        response = Response.create! valid_attributes
        put :update, {:id => response.to_param, :response => valid_attributes}, valid_session
        response.should redirect_to(response)
      end
    end

    describe "with invalid params" do
      it "assigns the response as @response" do
        response = Response.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Response.any_instance.stub(:save).and_return(false)
        put :update, {:id => response.to_param, :response => { "question_id" => "invalid value" }}, valid_session
        assigns(:response).should eq(response)
      end

      it "re-renders the 'edit' template" do
        response = Response.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Response.any_instance.stub(:save).and_return(false)
        put :update, {:id => response.to_param, :response => { "question_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested response" do
      response = Response.create! valid_attributes
      expect {
        delete :destroy, {:id => response.to_param}, valid_session
      }.to change(Response, :count).by(-1)
    end

    it "redirects to the responses list" do
      response = Response.create! valid_attributes
      delete :destroy, {:id => response.to_param}, valid_session
      response.should redirect_to(responses_url)
    end
  end

end
