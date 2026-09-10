package com.user_management.config;

import com.user_management.model.Role;
import com.user_management.model.Status;
import com.user_management.model.User;
import com.user_management.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DataSeeder implements CommandLineRunner {

    private final UserRepository userRepository;

    public DataSeeder(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public void run(String... args) {
        if (userRepository.count() == 0) {
            userRepository.save(new User("Rahul", "Sharma", "rahul@example.com", "9876543210", Role.ADMIN, Status.ACTIVE));
            userRepository.save(new User("Priya", "Patel", "priya@example.com", "9876500000", Role.USER, Status.ACTIVE));
            userRepository.save(new User("Amit", "Verma", "amit@example.com", "9876511111", Role.MANAGER, Status.INACTIVE));
            System.out.println("✅ Seeded 3 users into H2 database");
        }
    }
}