import React from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';

export const LearnMore: React.FC = () => {
  const { isAuthenticated } = useAuth();

  return (
    <div className="px-4 max-w-4xl mx-auto">
      <div className="py-12">
        <h1 className="text-4xl font-bold text-gray-900 mb-6 text-center">
          About BreadNotes 🍞
        </h1>
        
        <div className="prose prose-lg max-w-none">
          <div className="text-xl text-gray-700 mb-8 text-center">
            Your personal bread baking journal and community
          </div>

          <div className="grid md:grid-cols-2 gap-8 mb-12">
            <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
              <div className="text-3xl mb-4">📝</div>
              <h2 className="text-xl font-semibold text-gray-900 mb-3">Document Your Journey</h2>
              <p className="text-gray-600">
                Keep detailed records of your bread baking experiments. Track recipes, 
                techniques, results, and lessons learned with photos and notes.
              </p>
            </div>

            <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
              <div className="text-3xl mb-4">👥</div>
              <h2 className="text-xl font-semibold text-gray-900 mb-3">Share & Discover</h2>
              <p className="text-gray-600">
                Connect with fellow bakers, share your successes and failures, 
                and discover new techniques and recipes from the community.
              </p>
            </div>

            <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
              <div className="text-3xl mb-4">📈</div>
              <h2 className="text-xl font-semibold text-gray-900 mb-3">Track Progress</h2>
              <p className="text-gray-600">
                See how your bread making skills improve over time. Compare different 
                attempts and identify what techniques work best for you.
              </p>
            </div>

            <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
              <div className="text-3xl mb-4">🔍</div>
              <h2 className="text-xl font-semibold text-gray-900 mb-3">Learn & Improve</h2>
              <p className="text-gray-600">
                Build a searchable database of your baking experiences. Never forget 
                what worked, what didn't, and why.
              </p>
            </div>
          </div>

          <div className="bg-amber-50 rounded-lg p-8 mb-12">
            <h2 className="text-2xl font-bold text-gray-900 mb-4 text-center">
              Why BreadNotes?
            </h2>
            <div className="text-gray-700 space-y-4">
              <p>
                Bread baking is both an art and a science. Every loaf tells a story - the humidity 
                in your kitchen, the brand of flour you used, how long you kneaded, the temperature 
                of your oven. These details matter, and they're easy to forget.
              </p>
              <p>
                BreadNotes helps you capture these moments and learn from them. Whether you're 
                a beginner trying to get your first loaf to rise properly, or an experienced baker 
                perfecting your sourdough starter, having a record of your journey is invaluable.
              </p>
              <p>
                Plus, the bread baking community is incredibly supportive and knowledgeable. 
                By sharing your experiences - both successes and failures - you contribute to 
                a collective knowledge that helps everyone bake better bread.
              </p>
            </div>
          </div>

          <div className="text-center">
            {!isAuthenticated ? (
              <div className="space-y-4">
                <h2 className="text-2xl font-bold text-gray-900">Ready to start your bread journey?</h2>
                <Link
                  to="/login"
                  className="bg-amber-600 hover:bg-amber-700 text-white px-8 py-3 rounded-lg font-medium inline-block text-lg"
                >
                  Get Started for Free
                </Link>
                <div className="text-sm text-gray-600">
                  Join our community of passionate bread bakers
                </div>
              </div>
            ) : (
              <div className="space-y-4">
                <h2 className="text-2xl font-bold text-gray-900">Ready to document your next bake?</h2>
                <Link
                  to="/create"
                  className="bg-amber-600 hover:bg-amber-700 text-white px-8 py-3 rounded-lg font-medium inline-block text-lg"
                >
                  Create Your First Entry
                </Link>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};