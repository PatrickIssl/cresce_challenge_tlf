'use client'
import Link from 'next/link'
import { useState } from 'react'
import { HiMenu, HiX } from 'react-icons/hi'

const menuItems = [
  { icon: '🔄', label: 'Lista descontos', href: '/' },
]

export function Sidebar() {
  const [isSidebarOpen, setIsSidebarOpen] = useState(false)
  return (
    <>
      {isSidebarOpen && (
        <div
          data-testid="overlay"
          className="fixed inset-0 bg-black bg-opacity-50 z-30 lg:hidden"
          onClick={() => setIsSidebarOpen(false)}
        />
      )}
      <button
        data-testid="menu-button"
        onClick={() => setIsSidebarOpen(!isSidebarOpen)}
        className="fixed top-4 left-4 z-40 p-2 rounded-md bg-blue-600 text-white lg:hidden"
      >
        {isSidebarOpen ? <HiX size={24} /> : <HiMenu size={24} />}
      </button>
      <div
        data-testid="sidebar"
        className={`fixed top-0 left-0 h-full w-64 bg-[#0088CE] text-white transform transition-transform duration-200 ease-in-out lg:translate-x-0 z-40 ${isSidebarOpen ? 'translate-x-0' : '-translate-x-full'
          }`}
      >
        <div className="p-4 border-b border-blue-400 flex items-center">
          <button
            data-testid="close-button"
            onClick={() => setIsSidebarOpen(false)}
            className="mr-4 lg:hidden"
          >
            <HiX size={24} />
          </button>
          <img
            src="logo.png"
            alt="Vale Vantagens"
            className="w-32 m-auto"
          />
        </div>
        <nav className="mt-6">
          {menuItems.map((item, index) => (
            <Link
              key={index}
              href={item.href}
              className="flex items-center px-4 py-3 text-white hover:bg-blue-700 transition-colors"
            >
              <span className="mr-3">{item.icon}</span>
              <span>{item.label}</span>
            </Link>
          ))}
        </nav>
      </div>
    </>
  )
}
