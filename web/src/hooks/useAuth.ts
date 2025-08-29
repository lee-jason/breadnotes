import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { authService } from '../services/api';

export const useAuth = () => {
  const queryClient = useQueryClient();
  
  const { data: user, isLoading, isError } = useQuery({
    queryKey: ['user'],
    queryFn: authService.getCurrentUser,
    retry: false,
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
  
  const logoutMutation = useMutation({
    mutationFn: authService.logout,
    onSuccess: () => {
      queryClient.setQueryData(['user'], null);
      window.location.href = '/';
    },
  });
  
  const login = () => {
    authService.login();
  };
  
  const logout = () => {
    logoutMutation.mutate();
  };
  
  return {
    user,
    isLoading,
    isError,
    isAuthenticated: !!user && !isError,
    login,
    logout,
    isLoggingOut: logoutMutation.isPending,
  };
};