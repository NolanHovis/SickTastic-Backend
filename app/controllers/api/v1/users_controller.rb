# frozen_string_literal: true

module Api
  module V1
    # Handles endpoints related to users
    class UsersController < Api::V1::ApplicationController
      skip_before_action :authenticate, only: %i[login create]

      def login
        result = BlogApi::Auth.login(params[:email], params[:password], @ip)
        render_error(errors: 'User not authenticated', status: 401) and return unless result.success?

        payload = {
          user: UserBlueprint.render_as_hash(result.payload[:user], view: :login),
          token: TokenBlueprint.render_as_hash(result.payload[:token])
        }
        render_success(payload: payload)
      end

      def logout
        result = BlogApi::Auth.logout(@current_user, @token)
        render_error(errors: 'There was a problem logging out', status: :unprocessable_entity) and return unless result.success?

        render_success(payload: 'You have been logged out')
      end

      def create
        result = BlogApi::Users.new_user(params)
        render_error(errors: 'There was a problem creating a new user', status: 400) and return unless result.success?
        payload = {
          user: UserBlueprint.render_as_hash(result.payload, view: :normal)
        }
        #  TODO: Invite user to accept invitation via registered email
        render_success(payload: payload)
      end

      def me
        render_success(payload: UserBlueprint.render_as_hash(@current_user))
      end

      def all
        render_success(payload: UserBlueprint.render_as_hash(User.all))
      end

      def validate_invitation
        user = User.invite_token_is(params[:invitation_token]).invite_not_expired.first

        render_success(payload: { validated: false }) and return if user.nil?
        render_success(payload: { validated: true })
      end
    end
  end
end
