# frozen_string_literal: true

# changeマッチャーの否定を定義
RSpec::Matchers.define_negated_matcher :not_change, :change

# have_enqueued_jobマッチャーの否定を定義
RSpec::Matchers.define_negated_matcher :not_enqueue_job, :have_enqueued_job
